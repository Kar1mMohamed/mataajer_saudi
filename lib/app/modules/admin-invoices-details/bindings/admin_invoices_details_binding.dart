import 'package:get/get.dart';

import '../controllers/admin_invoices_details_controller.dart';

class AdminInvoicesDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminInvoicesDetailsController>(
      () => AdminInvoicesDetailsController(),
      fenix: true,
    );
  }
}
