import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/extensions/show_up_animation.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import '../controllers/choose_subscription_controller.dart';

class ChooseSubscriptionView extends GetView<ChooseSubscriptionController> {
  ChooseSubscriptionView({Key? key}) : super(key: key);

  @override
  final ChooseSubscriptionController controller =
      Get.put(ChooseSubscriptionController());

  Map<int, Widget> get stages => {
        1: chooseSubscription().showUpAnimation2,
        2: choosePeriod().showUpAnimation2,
        3: confirmation(), // animtion inside the children
      };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.stage == 1) {
          Get.back(result: {'status': 'cancel'});
          return false;
        } else {
          controller.stage--;
          controller.update();
          return false;
        }
      },
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: GetBuilder<ChooseSubscriptionController>(builder: (_) {
            if (controller.loading) {
              return const Center(child: LinearProgressIndicator());
            }
            return stages[controller.stage] ?? Container();
          }),
        ),
      ),
    );
  }

  Widget chooseSubscription() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'برجاء اختيار الباقة',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: controller.subscriptionsOptions
                .map(
                  (e) => _button(
                    e.name!,
                    onTap: () {
                      controller.currentSub = e;
                      controller.stage = 2;
                      controller.update();
                    },
                  ),
                )
                .toList()),
      ],
    );
  }

  Widget choosePeriod() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'برجاء اختيار الفترة',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                _button(
                  'شهري',
                  onTap: () {
                    int allowedDays = 30;
                    controller.currentSub.allowedDays = allowedDays;
                    controller.stage = 3;
                    controller.update();
                  },
                ),
                SizedBox(height: 20.h),
                Text(
                  '${controller.currentSub.monthlyPrice} ريال',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                _button('سنوي', onTap: () {
                  int allowedDays = 365;
                  controller.currentSub.allowedDays = allowedDays;
                  controller.stage = 3;
                  controller.update();
                }),
                SizedBox(height: 20.h),
                Text(
                  '${controller.currentSub.yearlyPrice} ريال',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget confirmation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text(
            'تأكيد البيانات',
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'الباقة',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  controller.currentSub.name ?? '',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'السعر',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  controller.currentSub.allowedDays == 30
                      ? '${controller.currentSub.monthlyPrice}'
                      : '${controller.currentSub.yearlyPrice}',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'الفترة',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  controller.currentSub.allowedDays == 30 ? 'شهري' : 'سنوي',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _button(
              'تأكيد',
              onTap: () {
                // controller.loading = true;
                // controller.update();
                // controller.confirmSubscription();
                Get.back(result: {
                  'status': 'success',
                  'data': controller.currentSub
                });
              },
            ),
            _button('الغاء', onTap: () {
              controller.stage = 1;
              // controller.update();
              Get.back(result: {'status': 'cancel'});
            }),
          ],
        ),
      ].map((e) => e.showUpAnimation2).toList(), // ANIMATE ALL CHILDREN
    );
  }

  Widget _button(String text, {void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50.h,
        width: 80.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15.sp,
              color: MataajerTheme.mainColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
