import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/back_button.dart';
import 'package:mataajer_saudi/database/notification.dart';

import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: const Color(0xFFF5F5F5),
      body: GetBuilder<NotificationsController>(builder: (_) {
        if (controller.loading) {
          return MataajerTheme.loadingWidget;
        }
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                notificationSection(
                    'اليوم', true, controller.todayNotifications),
                SizedBox(height: 20.h),
                notificationSection(
                    'الامس', false, controller.yesterdayNotifications),
                SizedBox(height: 20.h),
                notificationSection(
                    'اخرى', false, controller.otherNotifications),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget notificationSection(
      String text, bool isToday, List<NotificationModule> list) {
    if (list.isEmpty) {
      return Container();
    }
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
          itemBuilder: (context, index) => _notificationCard(list[index]),
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemCount: list.length,
          shrinkWrap: true,
        ),
      ],
    );
  }

  Widget _notificationCard(NotificationModule notification) {
    // String? image = notification.data?['image'];
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
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(50.r),
            //   child: LoadingImage(
            //     src: image,
            //     height: 65.h,
            //     width: 65.w,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // SizedBox(width: 10.w),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          '${notification.title}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                    ],
                  ),
                  Flexible(
                    child: Text(
                      '${notification.body}',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    notification.formateDate,
                    style: TextStyle(
                      color: const Color(0xFFB4B4B4),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
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
