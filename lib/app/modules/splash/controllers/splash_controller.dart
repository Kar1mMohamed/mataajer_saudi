import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';

class SplashController extends GetxController {
  final mainSettingsController = Get.find<MainSettingsController>();

  bool loading = false;

  Future<void> init() async {
    try {
      updateLoading();
      await mainSettingsController.getCategories();

      Get.offAndToNamed(Routes.LOGIN); // REAL INITAL ROUTE
    } catch (e) {
      print(e);
      KSnackBar.error('حدث خطأ أثناء تحميل البيانات');
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
