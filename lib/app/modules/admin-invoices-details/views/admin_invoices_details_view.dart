import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../../../widgets/back_button.dart';
import '../controllers/admin_invoices_details_controller.dart';

class AdminInvoicesDetailsView extends GetView<AdminInvoicesDetailsController> {
  const AdminInvoicesDetailsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: DataTable(
            columns: const [
              DataColumn(label: Text('رقم')),
              DataColumn(label: Text('التاريخ')),
              DataColumn(label: Text('اشتراك')),
              DataColumn(label: Text('اسم المتجر')),
              DataColumn(label: Text('المجال')),
              DataColumn(label: Text('الجوال')),
            ],
            rows: controller.adminInvoices.invoices
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(
                          controller.adminInvoices.shop.shopNumber.toString())),
                      DataCell(Text(e.date.toString())),
                      DataCell(Text(controller.adminInvoices.currentPackage)),
                      DataCell(Text(controller.adminInvoices.shop.name)),
                      DataCell(Text(
                          controller.adminInvoices.shop.getShopCategoryName)),
                      DataCell(Text(controller.adminInvoices.shop.phone ?? '')),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      title: Text('تفاصيل الفواتير',
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
