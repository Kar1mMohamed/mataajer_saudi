import 'package:get/get.dart';

import '../controllers/admin_invoices_controller.dart';

class AdminInvoicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminInvoicesController>(
      () => AdminInvoicesController(),
      fenix: true,
    );
  }
}
