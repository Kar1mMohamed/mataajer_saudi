import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/modules/home/controllers/home_controller.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class FavoritesController extends GetxController {
  final List<AdModule> ads = Get.arguments?['ads'] ?? [];
  final mainAccountController = Get.find<MainAccountController>();
  List<CategoryModule> get categoriesList =>
      Get.find<MainSettingsController>().mainCategories;

  List<AdModule> favs = [];

  void updateLoveState(AdModule ad) {
    mainAccountController.removeAdFromFav(ad);
    favs.remove(ad);
    update();
    Get.find<HomeController>().update();
  }

  Future<void> prepareFavs() async {
    log('ads: ${ads.length}');
    // favs = mainAccountController.getFavShops(ads);
    update();
  }

  @override
  void onInit() {
    prepareFavs();
    super.onInit();
  }
}
