import 'package:get/get.dart';

import '../controllers/admin_notification_controller.dart';

class AdminNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminNotificationController>(
      () => AdminNotificationController(),
    );
  }
}
