import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/modules/home/controllers/home_controller.dart';

class PreviewAdDialogController extends GetxController {
  final AdModule adModule;
  PreviewAdDialogController({required this.adModule});
  void addView() =>
      FirebaseFirestoreHelper.instance.addHit('offers', adModule.uid!);

  List<AdModule> get similarAds {
    try {
      return Get.find<HomeController>().offers.where(
        (element) {
          if (element.uid == adModule.shopUID) return false;
          if (element.categoryUIDs.contains(adModule.categoryUIDs.first)) {
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
