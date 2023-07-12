import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/modules/home/controllers/home_controller.dart';

class PreviewOfferDialogController extends GetxController {
  final AdModule offerModule;
  PreviewOfferDialogController({required this.offerModule});
  void addView() =>
      FirebaseFirestoreHelper.instance.addHit('offers', offerModule.uid!);

  List<AdModule> get similarAds {
    try {
      return Get.find<HomeController>().offers.where(
        (element) {
          if (element.shopUID == offerModule.shopUID) return false;
          if (element.uid == offerModule.uid) return false;
          if (element.categoryUIDs.contains(offerModule.categoryUIDs.first)) {
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

  @override
  void onInit() {
    addView();
    super.onInit();
  }
}
