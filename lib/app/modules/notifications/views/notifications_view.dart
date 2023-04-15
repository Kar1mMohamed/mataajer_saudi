import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/widgets/back_button.dart';

import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Color(0xFFF5F5F5),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              notificationSection('اليوم', true),
              SizedBox(height: 20.h),
              notificationSection('الامس', false),
              SizedBox(height: 20.h),
              notificationSection('اخرى', false),
            ],
          ),
        ),
      ),
    );
  }

  Widget notificationSection(String text, bool isToday) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            text,
            style: TextStyle(
              color:
                  isToday ? const Color(0xFF4CCA5A) : const Color(0xFFFF4949),
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => _notificationCard(),
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemCount: 10,
          shrinkWrap: true,
        ),
      ],
    );
  }

  Widget _notificationCard() {
    return Container(
      height: 95.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0.sp),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/mataajer-saudi.appspot.com/o/%D8%A7%D9%84%D9%88%D8%A7%D8%AF%D9%8A.jpg?alt=media&token=29 af9bc2-953f-48e5-a5ce-65a0ceeacdda',
                height: 65.h,
                width: 65.w,
                fit: BoxFit.cover,
                isAntiAlias: true,
              ),
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        'متجر',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        '10:00مساء',
                        style: TextStyle(
                          color: const Color(0xFFB4B4B4),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    """ تسوق منتجاتك المفضلة من أزياء وإلكترونيات ومنتجات المنزل والجمال ومنتجات """,
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
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
      title: Text('الاشعارات',
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
