import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_notification_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/cloud_messaging.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/functions/popup_ads.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class HomeController extends GetxController {
  final mainAccountController = Get.find<MainAccountController>();
  final mainSettingsController = Get.find<MainSettingsController>();
  bool get isShop => mainAccountController.isShopOwner;
  bool get isSignedIn => mainAccountController.isSignedIn && isShop;

  RxInt get notificationCount =>
      Get.find<MainNotificationController>().notificationCount;

  ShopModule? currentShop;

  int categorySelectedIndex = 0;

  bool loading = false;
  bool adsLoading = false;

  List<AdModule> get _dumpAds => List.generate(
        10,
        (index) => AdModule(
          uid: 'uid$index',
          name: 'name$index',
          hits: index,
          categoryUIDs: [
            if (index > 5) '6jXOqpwqxoaNmisfCY9m',
            '6soK9jRZO6S4fdBtB9FM',
            if (index.isEven) '9gPMKnAALDoL5vyYdebd',
            if (index.isOdd) 'ChSXe5tp6ZS96fKoaU2j',
            if (index < 5) 'OQA7tqLMtz1z7p3kWMvO',
            'TZ1qFoDmlzzs1APOmO5f'
          ],
          description: 'description$index',
          imageURL:
              'https://c8.alamy.com/comp/H3D3H0/small-indian-shop-sells-merchandise-per-single-unit-H3D3H0.jpg',
          validTill: DateTime.now().add(Duration(days: index)),
        ),
      );

  ///
  List<AdModule> _ads = <AdModule>[];

  List<AdModule> ads = <AdModule>[];

  List<AdModule> _offers = <AdModule>[];

  List<AdModule> offers = <AdModule>[];

  ///

  List<AdModule> get favAds => mainAccountController.getFavAds(_ads);

  Future<void> getAds() async {
    try {
      adsLoading = true;
      update(['all-ads']);
      final adsList = await FirebaseFirestoreHelper.instance.getAds();
      _ads = adsList;
      // _ads.addAll(_dumpAds);
      log('ads: ${_ads.length}');
    } catch (e) {
      print(e);
    } finally {
      ads = _ads;
      adsLoading = false;
      update(['all-ads']);
    }
  }

  Future<void> getOffers() async {
    try {
      adsLoading = true;
      update(['all-ads']);
      final offersList = await FirebaseFirestoreHelper.instance.getOffers();
      _offers = offersList;
      // _ads.addAll(_dumpAds);
      log('offers: ${_offers.length}');
    } catch (e) {
      print(e);
    } finally {
      ads = _ads;
      adsLoading = false;
      update(['all-ads']);
    }
  }

  void changeAdsForCategory(CategoryModule categoyry) {
    if (categoyry.name == 'الكل') {
      ads = _ads;
    } else {
      ads = _ads
          .where((element) => element.categoryUIDs.contains(categoyry.uid))
          .toList();
    }
    update(['all-ads']);
  }

  void updateLoveState(AdModule ad) {
    log('favs: $favAds');
    final isExistInFavs = favAds.any((e) => e.uid! == ad.uid!);
    if (isExistInFavs) {
      mainAccountController.removeAdFromFav(ad);
    } else {
      mainAccountController.addAdToFav(ad);
    }
    update(['shopCard-${ad.uid}']);
  }

  void updateShopCard(String shopUID) {
    update(['shopCard-$shopUID']);
  }

  void updateCategorySelectedIndex(int index) {
    categorySelectedIndex = index;
    update(['categories']);
  }

  List<CategoryModule> get categoriesList =>
      [CategoryModule(name: 'الكل'), ...mainSettingsController.mainCategories];

  Future<void> getCurrentShop() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return;
    }
    loading = true;
    update(['_appBarTitle']);
    try {
      currentShop = await FirebaseFirestoreHelper.instance
          .getShopModule(uid, getSubscriptions: true);
    } catch (e) {
      print(e);
      logout();
    } finally {
      loading = false;
      update(['_appBarTitle']);
    }
  }

  search(String? query) {
    searchAds(query);
    searchOffers(query);
  }

  void searchAds(String? query) {
    if (query == null || query.isEmpty) {
      ads = _ads;
    } else {
      ads = _ads
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update(['all-ads']);
  }

  void searchOffers(String? query) {
    if (query == null || query.isEmpty) {
      offers = _offers;
    } else {
      offers = _offers
          .where((element) =>
              element.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    update(['offers']);
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.ON_BARDING);
  }

  // bool isAdLoved(AdModule ad) => favAds.contains(ad);

  @override
  void onInit() async {
    CloudMessaging.sendFCMTokenToFirebase();

    if (isSignedIn) {
      await getCurrentShop();
    }
    await getAds();

    PopUpAdsFunctions.showPopUpAd();

    super.onInit();
  }
}
