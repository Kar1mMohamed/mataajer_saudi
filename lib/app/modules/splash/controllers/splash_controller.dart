import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';

import '../../../../database/helper/hive_helper.dart';
import '../../../functions/cloud_messaging.dart';
import '../../../utils/log.dart';

class SplashController extends GetxController {
  final mainSettingsController = Get.find<MainSettingsController>();

  bool loading = false;

  Future<void> init() async {
    try {
      updateLoading();

      await HiveHelper.initHive();
      await CloudMessaging.initialize();
      await GetStorage.init();
      await mainSettingsController.getCategories();
      await mainSettingsController.getSubscriptions();
      Get.offAndToNamed(Routes.ON_BARDING); // REAL INITAL ROUTE
    } catch (e) {
      log(e);
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
