import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/modules/home/controllers/home_controller.dart';

class PreviewDialogController extends GetxController {
  final AdModule adModule;
  PreviewDialogController({required this.adModule});
  void addView() => FirebaseFirestoreHelper.instance.addHit(adModule.uid!);

  List<AdModule> get similarAds => Get.find<HomeController>().ads.where(
        (element) {
          if (element.uid == adModule.uid) return false;
          if (element.categoryUIDs.contains(adModule.categoryUIDs.first)) {
            return true;
          }
          return false;
        },
      ).toList();

  @override
  void onInit() {
    addView();
    super.onInit();
  }
}
