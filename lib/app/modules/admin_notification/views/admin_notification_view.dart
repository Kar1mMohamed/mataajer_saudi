import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/extensions/for_admin.dart';
import 'package:mataajer_saudi/app/functions/url_launcher.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/drawer.dart';
import 'package:mataajer_saudi/app/widgets/rounded_button.dart';
import 'package:mataajer_saudi/app/widgets/textfield.dart';

import '../../../widgets/back_button.dart';
import '../controllers/admin_notification_controller.dart';

class AdminNotificationView extends GetView<AdminNotificationController> {
  const AdminNotificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: const MyDrawer(shops: [], isAdmin: true),
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: GetBuilder<AdminNotificationController>(builder: (_) {
          if (controller.loading) {
            return MataajerTheme.loadingWidget;
          }
          if (controller.notifications.isEmpty) {
            return const Center(child: Text('لا يوجد اشعارات'));
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: RoundedButton(
                        text: 'جديدة',
                        press: () {
                          controller.showIsNotActive = true;
                          controller.update();
                        },
                        color: controller.showIsNotActive
                            ? MataajerTheme.mainColor
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: RoundedButton(
                        text: 'جميع الاشعارات',
                        press: () {
                          controller.showIsNotActive = false;
                          controller.update();
                        },
                        color: controller.showIsNotActive
                            ? Colors.grey
                            : MataajerTheme.mainColor,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Builder(builder: (context) {
                    if (controller.notifications.isEmpty) {
                      return const Center(child: Text('لا يوجد اشعارات'));
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.notifications.length,
                      itemBuilder: (context, index) =>
                          _notificationCard(context, index),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.h),
                    );
                  }),
                ),
              ],
            ),
          );
        }).forAdmin,
      ),
    );
  }

  Widget _notificationCard(BuildContext context, int index) {
    return GetBuilder<AdminNotificationController>(
        id: '$index',
        builder: (_) {
          final notification = controller.notifications[index];
          final image = controller.getSenderUserImage(notification);

          if (controller.showIsNotActive && !notification.isCanAcceptOrCancel) {
            return const SizedBox.shrink();
          }

          return Container(
            padding:
                EdgeInsets.symmetric(vertical: 10.0.sp, horizontal: 10.0.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.r),
            ),
            child: controller.loading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          SizedBox(height: 15.h),
                          Text(
                            notification.sendingText,
                            style: MataajerTheme.tajawalTextStyle.copyWith(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: MataajerTheme.mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40.r,
                            backgroundColor: Colors.white,
                            backgroundImage: image != null
                                ? NetworkImage(image)
                                : const AssetImage(Assets.noImg)
                                    as ImageProvider,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notification.title ?? 'عنوان فارغ',
                                  style:
                                      MataajerTheme.tajawalTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: MataajerTheme.mainColor,
                                  )),
                              Text(
                                notification.formateDate,
                                style: MataajerTheme.tajawalTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        notification.body ?? 'نص فارغ',
                        textAlign: TextAlign.center,
                        style: MataajerTheme.tajawalTextStyle.copyWith(
                            fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          final url = notification.data?['link'];
                          URLLauncherFuntions.launchURL(url);
                        },
                        child: Text(
                          notification.data?['link'] ?? 'رابط فارغ',
                          textAlign: TextAlign.center,
                          style: MataajerTheme.tajawalTextStyle.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      if (notification.cancelReason != null)
                        Text(
                          'تم الرفض بسبب: ${notification.cancelReason ?? ''}',
                          textAlign: TextAlign.center,
                          style: MataajerTheme.tajawalTextStyle.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                          ),
                        ),
                      const SizedBox(height: 10),
                      if (!(notification.isActive ?? false) &&
                          notification.cancelReason == null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RoundedButton(
                              text: 'قبول',
                              press: () {
                                controller.accept(notification, index);
                              },
                              color: Colors.green,
                              width: 140.w,
                              verticalPadding: 10.h,
                            ),
                            RoundedButton(
                              text: 'رفض',
                              press: () {
                                final cancelReasonController =
                                    TextEditingController();
                                Get.dialog(
                                  Dialog(
                                    backgroundColor: Colors.white,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.0.sp,
                                          vertical: 10.0.sp),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          textField(
                                            hint: 'سبب الرفض',
                                            controller: cancelReasonController,
                                          ),
                                          RoundedButton(
                                            text: 'رفض',
                                            press: () async {
                                              await controller.cancelFunction(
                                                notification
                                                  ..cancelReason =
                                                      cancelReasonController
                                                          .text,
                                                index,
                                              );
                                              Get.back();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              color: Colors.red,
                              width: 140.w,
                              verticalPadding: 10.h,
                            ),
                          ],
                        ),
                    ],
                  ),
          );
        });
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
