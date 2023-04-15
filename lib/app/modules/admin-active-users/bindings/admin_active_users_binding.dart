import 'package:get/get.dart';

import '../controllers/admin_active_users_controller.dart';

class AdminActiveUsersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminActiveUsersController>(
      () => AdminActiveUsersController(),
      fenix: true,
    );
  }
}
