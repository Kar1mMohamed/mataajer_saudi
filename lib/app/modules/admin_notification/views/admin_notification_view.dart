import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/drawer.dart';
import 'package:mataajer_saudi/app/widgets/image_loading.dart';
import 'package:mataajer_saudi/app/widgets/rounded_button.dart';
import 'package:path/path.dart';

import '../../../widgets/back_button.dart';
import '../controllers/admin_notification_controller.dart';

class AdminNotificationView extends GetView<AdminNotificationController> {
  const AdminNotificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: const MyDrawer(ads: [], isShop: false, isAdmin: true),
      body: GetBuilder<AdminNotificationController>(builder: (_) {
        if (controller.loadng) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 1,
            itemBuilder: (context, index) => _notificationCard(context, index),
          ),
        );
      }),
    );
  }

  Widget _notificationCard(BuildContext context, int index) {
    // final notification = controller.notifications[index];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 10.0.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50.r),
                child: LoadingImage(
                  src: 'https://i.stack.imgur.com/l60Hf.png',
                  height: 75.h,
                  width: 75.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('متجر نون',
                      style: MataajerTheme.tajawalTextStyle.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: MataajerTheme.mainColor,
                      )),
                  Text('تسوق منتجات',
                      style: MataajerTheme.tajawalTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,
                      )),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'احدث عروض شهر رمضان – عروض رمضان 2023 – نوفر لكم أحدث عروض شهر رمضان الكريم في المملكة العربية السعودية فى كل الاسواق والهايبرماركت',
            style: MataajerTheme.tajawalTextStyle
                .copyWith(fontSize: 13, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundedButton(
                text: 'قبول',
                press: () {},
                color: Colors.green,
                width: 140.w,
                verticalPadding: 10.h,
              ),
              RoundedButton(
                text: 'رفض',
                press: () {},
                color: Colors.red,
                width: 140.w,
                verticalPadding: 10.h,
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      title: Text('الاشعارات المستقبلة',
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
