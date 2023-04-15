import 'package:get/get.dart';

import '../controllers/choose_subscription_controller.dart';

class ChooseSubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChooseSubscriptionController>(
      () => ChooseSubscriptionController(),
    );
  }
}
