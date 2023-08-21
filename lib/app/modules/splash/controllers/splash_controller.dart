import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import '../../../utils/log.dart';

class SplashController extends GetxController {
  final mainSettingsController = Get.find<MainSettingsController>();

  bool loading = false;

  Future<void> init() async {
    try {
      updateLoading();

      FirebaseAuth.instance.setLanguageCode('ar');
      await mainSettingsController.getCategories();
      await mainSettingsController.getSubscriptions();
      Get.offAllNamed(Routes.ON_BARDING); // REAL INITAL ROUTE
    } catch (e) {
      log(e);
      KSnackBar.error('حدث خطأ ما SPLASH');
    }
  }

  void updateLoading() {
    loading = !loading;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    await init();
  }
}
