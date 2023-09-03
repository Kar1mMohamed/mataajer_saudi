import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/offer_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/modules/home/controllers/home_controller.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class PreviewOfferDialogController extends GetxController {
  final OfferModule offerModule;
  PreviewOfferDialogController({required this.offerModule});
  void addView() =>
      FirebaseFirestoreHelper.instance.addHit('offers', offerModule.uid!);

  List<OfferModule> get similarAds {
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
    log('PreviewOfferDialogController initialized for uid: ${offerModule.name}');
    super.onInit();
  }
}
