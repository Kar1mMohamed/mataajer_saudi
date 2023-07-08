import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/back_button.dart';
import 'package:mataajer_saudi/app/widgets/rounded_button.dart';

import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GetBuilder<ResetPasswordController>(builder: (_) {
          if (controller.loading) {
            return SizedBox(
              height: context.height,
              width: context.width,
              child: MataajerTheme.loadingWidget,
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(Assets.logo),
                ),
                SizedBox(height: 5.h),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'التحقق من البريد الالكتروني',
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'تم ارسال بريد التحقق لبريدكم الالكتروني',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                // Directionality(
                //   textDirection: TextDirection.ltr,
                //   child: OTPTextField(
                //     length: 4,
                //     keyboardType: TextInputType.number,
                //     width: MediaQuery.of(context).size.width,
                //     outlineBorderRadius: 50.r,
                //     style:
                //         TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
                //     fieldWidth: 50.w,
                //     textFieldAlignment: MainAxisAlignment.spaceAround,
                //     onChanged: (v) {},
                //     onCompleted: (pin) {
                //       log("Completed: " + pin);
                //     },
                //   ),
                // ),
                // SizedBox(height: 10.h),
                TextButton(
                  onPressed: () => controller.resendEmailVerification(),
                  child: Text(
                    'أعد إرسال البريد الالكتروني',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF366EE9),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                RoundedButton(
                    text: 'تاكيد',
                    press: () => controller.checkIFEmailVerified()),
              ],
            ),
          );
        }),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        controller.title,
        style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
      ),
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
