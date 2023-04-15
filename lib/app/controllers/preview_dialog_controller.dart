import 'package:get/get.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';

class PreviewDialogController extends GetxController {
  final String adUID;
  PreviewDialogController({required this.adUID});
  void addView() => FirebaseFirestoreHelper.instance.addHit(adUID);

  @override
  void onInit() {
    addView();
    super.onInit();
  }
}
