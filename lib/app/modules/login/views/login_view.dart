import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/app/widgets/rounded_button.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      resizeToAvoidBottomInset: false,
      body: GetBuilder<LoginController>(builder: (_) {
        return Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50.h),
                Image.asset(Assets.loginImage),
                SizedBox(height: 10.h),
                Text('هل انت زائر ام صاحب متاجر؟!',
                    style: TextStyle(fontSize: 17.sp)),
                SizedBox(height: 10.h),
                InkWell(
                    onTap: () {
                      controller.isShopOwner.value = false;
                      controller.update();
                    },
                    child: _chooseItem(Assets.groupIcon, 'زائر',
                        !controller.isShopOwner.value)),
                SizedBox(height: 20.h),
                InkWell(
                    onTap: () {
                      controller.isShopOwner.value = true;
                      controller.update();
                    },
                    child: _chooseItem(Assets.personIcon, 'صاحب متجر',
                        controller.isShopOwner.value)),
                SizedBox(height: 30.h),
                RoundedButton(
                  text: 'دخول',
                  press: () {
                    if (controller.isShopOwner.value) {
                      Get.offAndToNamed(Routes.SHOP_LOGIN_AND_REGISTER);
                    } else {
                      Get.offAndToNamed(Routes.HOME);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _chooseItem(String imageAsset, String text, bool isChoosed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      height: 60.h,
      width: 300.w,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF7F7),
                      borderRadius: BorderRadius.circular(20.r)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(imageAsset),
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  text,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            if (isChoosed)
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(Assets.rightCheckIcon),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
