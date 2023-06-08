import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/modules/choose_subscription_module.dart';

class ChooseSubscriptionController extends GetxController {
  bool loading = false;
  int stage = 1;

  List<ChooseSubscriptionModule> get subscriptionsOptions =>
      Get.find<MainSettingsController>().subscriptions;

  ChooseSubscriptionModule currentSub = ChooseSubscriptionModule();

  @override
  void onClose() {
    loading = false;
    stage = 1;
    currentSub = ChooseSubscriptionModule();
    super.onClose();
  }
}
