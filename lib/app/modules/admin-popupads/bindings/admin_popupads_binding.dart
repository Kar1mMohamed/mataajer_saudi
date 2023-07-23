import 'package:get/get.dart';

import '../controllers/admin_popupads_controller.dart';

class AdminPopupadsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminPopupadsController>(
      () => AdminPopupadsController(),
      fenix: true,
    );
  }
}
