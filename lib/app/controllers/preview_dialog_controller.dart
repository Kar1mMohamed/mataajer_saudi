import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/modules/home/controllers/home_controller.dart';

class PreviewDialogController extends GetxController {
  final AdModule adModule;
  PreviewDialogController({required this.adModule});
  void addView() => FirebaseFirestoreHelper.instance.addHit(adModule.uid!);

  List<AdModule> get similarAds {
    try {
      return Get.find<HomeController>().ads.where(
        (element) {
          if (element.uid == adModule.uid) return false;
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
