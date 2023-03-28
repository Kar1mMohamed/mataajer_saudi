import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/constants.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';

class HomeController extends GetxController {
  final mainAccountController = Get.find<MainAccountController>();
  final mainSettingsController = Get.find<MainSettingsController>();
  bool get isShop => mainAccountController.isShopOwner;
  bool get isSignedIn => mainAccountController.isSignedIn && isShop;

  ShopModule? currentShop;

  int categorySelectedIndex = 0;

  bool loading = false;

  List<ShopModule> get _dumpShops => List.generate(
        10,
        (index) => ShopModule(
          uid: 'uid$index',
          name: 'name$index',
          categoriesUIDs: [
            '6jXOqpwqxoaNmisfCY9m',
            '6soK9jRZO6S4fdBtB9FM',
            '9gPMKnAALDoL5vyYdebd',
            'ChSXe5tp6ZS96fKoaU2j',
            'OQA7tqLMtz1z7p3kWMvO',
            'TZ1qFoDmlzzs1APOmO5f'
          ],
          description: 'description$index',
          image:
              'https://c8.alamy.com/comp/H3D3H0/small-indian-shop-sells-merchandise-per-single-unit-H3D3H0.jpgß',
        ),
      );

  List<ShopModule> get shops => _dumpShops;

  List<ShopModule> get favShops => mainAccountController.getFavShops(shops);

  void updateLoveState(ShopModule shop) {
    final isExistInFavs = favShops.any((element) => element.uid == shop.uid);
    if (isExistInFavs) {
      mainAccountController.removeShopFromFav(shop);
    } else {
      mainAccountController.addShopToFav(shop);
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
      currentShop = await FirebaseFirestoreHelper.instance.getShopModule(uid);
    } catch (e) {
      print(e);
    } finally {
      loading = false;
      update(['_appBarTitle']);
    }
  }

  @override
  void onInit() async {
    if (isSignedIn) {
      await getCurrentShop();
    }
    super.onInit();
  }
}
