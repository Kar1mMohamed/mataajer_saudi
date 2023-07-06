import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/modules/home/controllers/home_controller.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class FavoritesController extends GetxController {
  final List<ShopModule> shops = Get.arguments?['shops'] ?? [];
  final mainAccountController = Get.find<MainAccountController>();
  List<CategoryModule> get categoriesList =>
      Get.find<MainSettingsController>().mainCategories;

  List<ShopModule> favs = [];

  void updateLoveState(ShopModule shop) {
    mainAccountController.removeAdFromFav(shop);
    favs.remove(shop);
    update();
    Get.find<HomeController>().update();
  }

  Future<void> prepareFavs() async {
    log('shops: ${shops.length}');
    favs = mainAccountController.getFavShops(shops);
    update();
  }

  @override
  void onInit() {
    prepareFavs();
    super.onInit();
  }
}
