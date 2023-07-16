import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/app/admin_invoice_shop_module.dart';

class AdminInvoicesDetailsController extends GetxController {
  AdminInvoiceShopModule get adminInvoices =>
      Get.arguments?['adminInvoiceShopModule'] ?? [];
  bool loading = false;
}
