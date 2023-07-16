import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/app/admin_invoice_shop_module.dart';
import 'package:mataajer_saudi/app/data/modules/invoice_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';

import '../../../routes/app_pages.dart';

class AdminInvoicesController extends GetxController {
  bool loading = false;
  List<ShopModule> _shops = [];
  List<AdminInvoiceShopModule> adminInvoices = [];
  bool isAscending = true;
  int? sortColumnIndex;
  Future<List<ShopModule>> _getShops() async {
    try {
      final shops =
          await FirebaseFirestoreHelper.instance.getShops(forAdmin: true);

      _shops = shops;

      return shops;
    } catch (e) {
      log('AdminInvoicesController: getShops: $e');
      return [];
    }
  }

  Future<List<InvoiceModule>> _getShopInvoices(String shopUID) async {
    try {
      final invoices =
          await FirebaseFirestoreHelper.instance.getShopInvoices(shopUID);

      return invoices;
    } catch (e) {
      log('AdminInvoicesController: getShopInvoices: $e');
      return [];
    }
  }

  Future<void> getAdminInvoices() async {
    loading = true;
    update();
    try {
      final shops = await _getShops();

      for (var shop in shops) {
        final invoices = await _getShopInvoices(shop.uid!);

        adminInvoices
            .add(AdminInvoiceShopModule(shop: shop, invoices: invoices));
      }
    } catch (e) {
      log('AdminInvoicesController: getAdminInvoices: $e');
    } finally {
      loading = false;
      update();
    }
  }

  void initShopNumber(ShopModule shop) async {
    if (shop.shopNumber != null) return;
    try {
      await shop.initShopNumberForAdmins(_shops);
      _shops = await _getShops();
      KSnackBar.success(
          'تم تعيين رقم المتجر ${shop.shopNumber} للمتجر ${shop.name}');
      update();
    } catch (e) {
      log(e);
    }
  }

  void goToInvoicesDetails(AdminInvoiceShopModule e) {
    if (e.invoices.isEmpty) return;
    Get.toNamed(
      Routes.ADMIN_INVOICES_DETAILS,
      arguments: {'adminInvoiceShopModule': e},
    );
  }

  void sortShopNumber(int index, bool ascending) {
    isAscending = !isAscending;
    sortColumnIndex = index;

    log('sortShopNumber: $index, $ascending');
    if (ascending) {
      adminInvoices.sort(
          (a, b) => (a.shop.shopNumber ?? 0).compareTo(b.shop.shopNumber ?? 0));
    } else {
      adminInvoices.sort(
          (a, b) => (b.shop.shopNumber ?? 0).compareTo(a.shop.shopNumber ?? 0));
    }

    update();
  }

  void sortAmounts(int index, bool ascending) {
    isAscending = !isAscending;
    sortColumnIndex = index;

    log('sortAmounts: $index, $ascending');
    if (ascending) {
      adminInvoices.sort((a, b) => (a.totalAmount).compareTo(b.totalAmount));
    } else {
      adminInvoices.sort((a, b) => (b.totalAmount).compareTo(a.totalAmount));
    }

    update();
  }

  @override
  void onInit() async {
    super.onInit();
    await getAdminInvoices();
  }
}
