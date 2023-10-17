import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_notification_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/controllers/online_now_controller.dart';
import 'package:mataajer_saudi/app/data/modules/banner.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/functions/popup_ads.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import '../../../data/modules/offer_module.dart';

class HomeController extends GetxController {
  final mainAccountController = Get.find<MainAccountController>();
  final mainSettingsController = Get.find<MainSettingsController>();
  bool get isShop => mainAccountController.isShopOwner;
  bool get isSignedIn => mainAccountController.isSignedIn && isShop;

  RxInt get notificationCount =>
      Get.find<MainNotificationController>().notificationCount;

  bool isHomeFullyInitilized = false;

  ShopModule? currentShop;

  int categorySelectedIndex = 0;

  bool loading = false;
  bool adsLoading = false;

  Stream<DocumentSnapshot<Map<String, dynamic>>> get onlineNowStream =>
      Get.find<OnlineNowController>().onlineNowStream();

  //
  List<ShopModule> get staticAds =>
      shops.where((element) => element.isStaticAd ?? false).toList();

  List<ShopModule> get mostViewed =>
      shops..sort((a, b) => (b.hits ?? 0).compareTo(a.hits ?? 0));
  // mostViewed.addAll(controller.shops);
  // mostViewed.sort((a, b) => (b.hits ?? 0).compareTo(a.hits ?? 0));

  List<ShopModule> get mostOffers {
    var shops = this.shops;
    shops.sort((a, b) => (b.hits ?? 0).compareTo(a.hits ?? 0));

    return shops;
  }

  List<ShopModule> get others =>
      shops.where((element) => element.isOtherAd).toList();

  List<BannerModule> homeBanners = [];

  //

  // List<ShopModule> get _dumpShops => List.generate(
  //       10,
  //       (index) => ShopModule(
  //         uid: 'uid$index',
  //         name: 'name$index',
  //         hits: index,
  //         categoriesUIDs: [
  //           if (index > 5) '6jXOqpwqxoaNmisfCY9m',
  //           '6soK9jRZO6S4fdBtB9FM',
  //           if (index.isEven) '9gPMKnAALDoL5vyYdebd',
  //           if (index.isOdd) 'ChSXe5tp6ZS96fKoaU2j',
  //           if (index < 5) 'OQA7tqLMtz1z7p3kWMvO',
  //           'TZ1qFoDmlzzs1APOmO5f'
  //         ],
  //         description: 'description$index',
  //         image:
  //             'https://c8.alamy.com/comp/H3D3H0/small-indian-shop-sells-merchandise-per-single-unit-H3D3H0.jpg',
  //         validTill: DateTime.now().add(Duration(days: index)),
  //       ),
  //     );

  ///
  // List<OfferModule> _ads = <OfferModule>[];

  // List<OfferModule> ads = <OfferModule>[];

  List<ShopModule> _shops = <ShopModule>[];

  List<ShopModule> shops = <ShopModule>[];

  List<OfferModule> _offers = <OfferModule>[];
  List<OfferModule> get getAllOffers => _offers;

  List<OfferModule> offers = <OfferModule>[];

  ///

  // List<OfferModule> get favAds => mainAccountController.getFavAds(_ads);

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
  //     log(e);
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
      log('shops: ${_shops}');
    } catch (e) {
      log(e);
    } finally {
      shops = _shops;
      adsLoading = false;
      update(['all-ads']);
    }
  }

  Future<void> getOffers() async {
    try {
      adsLoading = true;
      updateoffersCarousel();

      final offersList = await FirebaseFirestoreHelper.instance.getOffers();
      _offers = offersList;
      log('_offers: ${_offers.length}');
    } catch (e) {
      log(e);
    } finally {
      offers = _offers;
      adsLoading = false;
      updateoffersCarousel();
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

  void updateOfferCard(String offerUID) {
    update(['offerCard-$offerUID']);
  }

  void updateCategorySelectedIndex(int index) {
    categorySelectedIndex = index;
    update(['categories']);
  }

  void updateoffersCarousel() {
    update(['offersCarousel']);
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
      log(e);
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
      log(_shops.map((e) => e.keywords).toList());
      shops = _shops
          .where(
            (element) =>
                element.name.toLowerCase().contains(query.toLowerCase()) ||
                (element.keywords ?? []).contains(query),
          )
          .toList();
    }
    update(['all-ads']);
  }

  void searchOffers(String? query) {
    if (query == null || query.isEmpty) {
      offers = _offers;
    } else {
      offers = _offers
          .where(
            (element) =>
                element.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    update(['offers']);
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed(Routes.ON_BARDING);
  }

  // bool isAdLoved(OfferModule ad) => favAds.contains(ad);

  Future<void> onRefresh() async {
    await Future.wait([
      getHomeBanners(),
      getShops(),
      getOffers(),
    ]);
  }

  void onINIT() async {
    isHomeFullyInitilized = false;
    update();

    await Future.wait([
      if (isSignedIn) getCurrentShop(),
      getShops(),
      getOffers(),
      getHomeBanners(),
    ]);
    Get.find<MainNotificationController>().getNotificationsCount();

    if (FirebaseAuth.instance.currentUser == null) {
      PopUpAdsFunctions.showPopUpAd();
    }

    isHomeFullyInitilized = true;
    update();
  }

  Future<void> getHomeBanners() async {
    loading = true;
    updateHomeBanners();
    try {
      var banners = await FirebaseFirestoreHelper.instance.getHomeBanners();
      homeBanners = banners;

      log('got home banners: ${homeBanners.length}');
    } catch (e) {
      log(e);
    } finally {
      loading = false;
      updateHomeBanners();
    }
  }

  void updateHomeBanners() {
    update(['homeBanners']);
  }

  @override
  void onInit() {
    super.onInit();
    onINIT();
  }
}
