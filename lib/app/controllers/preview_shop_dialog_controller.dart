import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/offer_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/modules/home/controllers/home_controller.dart';

class PreviewShopDialogController extends GetxController {
  final ShopModule shopModule;
  PreviewShopDialogController({required this.shopModule});
  void addView() =>
      FirebaseFirestoreHelper.instance.addHit('shops', shopModule.uid!);

  List<ShopModule> get similarShops {
    try {
      return Get.find<HomeController>().shops.where(
        (element) {
          if (element.uid == shopModule.uid) return false;
          if (element.categoriesUIDs
              .contains(shopModule.categoriesUIDs.first)) {
            return true;
          }
          return false;
        },
      ).toList();
    } catch (e) {
      // Mostly because of HomeController not initialized yet
      return [];
    }
  }

  List<OfferModule> get allOffers {
    try {
      return Get.find<HomeController>().getAllOffers.where(
        (element) {
          if (element.shopUID == shopModule.uid) return true;
          return false;
        },
      ).toList();
    } catch (e) {
      // Mostly because of HomeController not initialized yet
      return [];
    }
  }

  @override
  void onInit() {
    addView();
    super.onInit();
  }
}
