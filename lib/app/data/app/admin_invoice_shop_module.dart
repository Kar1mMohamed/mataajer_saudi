import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/modules/invoice_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';

class AdminInvoiceShopModule {
  final ShopModule shop;
  final List<InvoiceModule> invoices;

  double get totalAmount {
    double total = 0;
    for (var invoice in invoices) {
      total += invoice.amount ?? 0;
    }
    return total;
  }

  String get currentPackage {
    if (invoices.isEmpty) return 'غير مشترك';
    final invoice = invoices.last;
    final subscriptionSettingUID = invoice.subscriptionSettingUID;
    final subscriptionSetting = Get.find<MainSettingsController>()
        .subscriptions
        .where((element) => element.uid == subscriptionSettingUID)
        .first;

    return subscriptionSetting.name ?? '';
  }

  AdminInvoiceShopModule({required this.shop, required this.invoices});

  @override
  String toString() {
    return 'AdminInvoiceShopModule(shop: $shop, invoices: $invoices)';
  }
}
