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

  // List<AdModule> get _dumpAds => List.generate(
  //       10,
  //       (index) => AdModule(
  //         uid: 'uid$index',
  //         name: 'name$index',
  //         hits: index,
  //         categoryUIDs: [
  //           if (index > 5) '6jXOqpwqxoaNmisfCY9m',
  //           '6soK9jRZO6S4fdBtB9FM',
  //           if (index.isEven) '9gPMKnAALDoL5vyYdebd',
  //           if (index.isOdd) 'ChSXe5tp6ZS96fKoaU2j',
  //           if (index < 5) 'OQA7tqLMtz1z7p3kWMvO',
  //           'TZ1qFoDmlzzs1APOmO5f'
  //         ],
  //         description: 'description$index',
  //         imageURL:
  //             'https://c8.alamy.com/comp/H3D3H0/small-indian-shop-sells-merchandise-per-single-unit-H3D3H0.jpg',
  //         validTill: DateTime.now().add(Duration(days: index)),
  //       ),
  //     );

  ///
  // List<AdModule> _ads = <AdModule>[];

  // List<AdModule> ads = <AdModule>[];

  List<ShopModule> _shops = <ShopModule>[];

  List<ShopModule> shops = <ShopModule>[];

  List<AdModule> _offers = <AdModule>[];

  List<AdModule> offers = <AdModule>[];

  ///

  // List<AdModule> get favAds => mainAccountController.getFavAds(_ads);

  List<ShopModule> get favShops => mainAccountController.getFavShops(_shops);

  // Future<void> getAds() async {
  //   try {
  //     adsLoading = true;
  //     update(['all-ads']);
  //     final adsList = await FirebaseFirestoreHelper.instance.getAds();
  //     _ads = adsList;
  //     // _ads.addAll(_dumpAds);
  //     log('ads: ${_ads.length}');
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     ads = _ads;
  //     adsLoading = false;
  //     update(['all-ads']);
  //   }
  // }

  Future<void> getShops() async {
    try {
      adsLoading = true;
      update(['all-ads']);
      final shopsList = await FirebaseFirestoreHelper.instance.getShops();
      _shops = shopsList;
      log('shops: ${_shops.length}');
    } catch (e) {
      print(e);
    } finally {
      shops = _shops;
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
      log('offers: ${_offers.length}');
    } catch (e) {
      print(e);
    } finally {
      offers = _offers;
      adsLoading = false;
      update(['all-ads']);
    }
  }

  void changeAdsForCategory(CategoryModule categoyry) {
    if (categoyry.name == 'الكل') {
      // ads = _ads;
      shops = _shops;
    } else {
      // ads = _ads
      shops = _shops
          .where((element) => element.categoriesUIDs.contains(categoyry.uid))
          .toList();
    }
    update(['all-ads']);
  }

  void updateLoveState(ShopModule shop) {
    // log('favs: $favAds');
    log('favShops: $favShops');
    // final isExistInFavs = favAds.any((e) => e.uid! == ad.uid!);
    final isExistInFavs = favShops.any((e) => e.uid == shop.uid);
    if (isExistInFavs) {
      mainAccountController.removeAdFromFav(shop);
    } else {
      mainAccountController.addAdToFav(shop);
    }
    update(['shopCard-${shop.uid}']);
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
    searchShops(query);
    searchOffers(query);
  }

  // void searchAds(String? query) {
  //   if (query == null || query.isEmpty) {
  //     ads = _ads;
  //   } else {
  //     ads = _ads
  //         .where((element) =>
  //             element.name.toLowerCase().contains(query.toLowerCase()))
  //         .toList();
  //   }
  //   update(['all-ads']);
  // }

  void searchShops(String? query) {
    if (query == null || query.isEmpty) {
      shops = _shops;
    } else {
      shops = _shops
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
    // await getAds();
    await getShops();

    PopUpAdsFunctions.showPopUpAd();

    super.onInit();
  }
}
