import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/extensions/for_admin.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/back_button.dart';

import '../controllers/admin_invoices_controller.dart';

class AdminInvoicesView extends GetView<AdminInvoicesController> {
  const AdminInvoicesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: GetBuilder<AdminInvoicesController>(builder: (_) {
        if (controller.loading) {
          return MataajerTheme.loadingWidget;
        }
        return Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: DataTable(
              sortAscending: controller.isAscending,
              sortColumnIndex: controller.sortColumnIndex,
              columns: [
                DataColumn(
                  label: const Text('رقم'),
                  numeric: true,
                  onSort: (columnIndex, ascending) {
                    controller.sortShopNumber(
                        columnIndex, controller.isAscending);
                  },
                ),
                const DataColumn(label: Text('المتجر')),
                DataColumn(
                  label: const Text('المبالغ'),
                  onSort: (columnIndex, ascending) =>
                      controller.sortAmounts(columnIndex, ascending),
                ),
                const DataColumn(label: Text('الباقة الحالية')),
                const DataColumn(label: Text('رقم الجوال')),
                const DataColumn(label: Text('الايميل')),
                const DataColumn(label: Text('المجال')),
              ],
              rows: controller.adminInvoices
                  .map(
                    (e) => DataRow(
                      cells: [
                        DataCell(
                          Text(e.shop.shopNumber.toString()),
                          onLongPress: () => controller.initShopNumber(e.shop),
                        ),
                        DataCell(Text(e.shop.name)),
                        DataCell(Text(e.totalAmount.toStringAsFixed(2)),
                            onTap: () => controller.goToInvoicesDetails(e)),
                        DataCell(Text(e.currentPackage)),
                        DataCell(Text(e.shop.phone ?? '')),
                        DataCell(Text(e.shop.email ?? '')),
                        DataCell(Text(e.shop.getShopCategoryName)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      }).forAdmin,
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      title: Text('الفواتير',
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500)),
      centerTitle: true,
      toolbarHeight: 50.h,
      leading: Transform.translate(
        offset: const Offset(-10, 0),
        child: const CustomBackButton(),
      ),
      leadingWidth: 50.w,
    );
  }
}
