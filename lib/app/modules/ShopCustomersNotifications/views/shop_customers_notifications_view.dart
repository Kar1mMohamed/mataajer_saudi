import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/back_button.dart';
import 'package:mataajer_saudi/app/widgets/drawer.dart';
import 'package:mataajer_saudi/app/widgets/rounded_button.dart';
import '../controllers/shop_customers_notifications_controller.dart';

class ShopCustomersNotificationsView
    extends GetView<ShopCustomersNotificationsController> {
  const ShopCustomersNotificationsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: MyDrawer(shops: const [], isShop: controller.isShop),
      body: GetBuilder<ShopCustomersNotificationsController>(builder: (_) {
        if (controller.loading) {
          return MataajerTheme.loadingWidget;
        }
        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [
                  Image.asset(Assets.bilNotificationVector),
                  const SizedBox(height: 20),
                  const Text(
                    "ارسل اشعار لعملائك وقدم لهم المزيد من العروض ",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 7.h),
                  const Text(
                    "يمكن ارسال 3 اشعارات شهريا",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  SizedBox(height: 40.h),
                  _fieldItem(
                    "نص الاشعار",
                    controller.notTitleController,
                    maxLines: 1,
                    onFieldSubmitted: (p0) {
                      // unfocus keyboard
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  SizedBox(height: 40.h),
                  RoundedButton(
                    text: 'ارسال',
                    press: () => controller.sendNotification(),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      title: Text('ارسال اشعار',
          style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500)),
      centerTitle: true,
      toolbarHeight: 50.h,
      leading: Builder(builder: (context) {
        return InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Image.asset(
            Assets.menuIcon,
            width: 20.w,
            height: 20.h,
          ),
        );
      }),
      actions: [
        // THIS TO ROTATE THE BACK BUTTON
        RotatedBox(
          quarterTurns: 2,
          child: Transform.translate(
            offset: const Offset(-10, 0),
            child: const CustomBackButton(),
          ),
        ),
      ],
      leadingWidth: 50.w,
    );
  }

  Widget _fieldItem(
    String text,
    TextEditingController controller, {
    bool isPassword = false,
    bool isEmail = false,
    String? imageAssetIcon,
    bool showPassword = false,
    void Function()? showPasswordTap,
    void Function(String)? onFieldSubmitted,
    int? maxLines,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Tajawal',
          ),
        ),
        SizedBox(height: 5.h),
        SizedBox(
          // height: height,
          child: TextFormField(
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Tajawal',
            ),
            obscureText: isPassword ? !showPassword : false,
            obscuringCharacter: '*',
            controller: controller,
            maxLines: maxLines,
            decoration: !(imageAssetIcon != null)
                ? null
                : InputDecoration(
                    fillColor: const Color(0xFFF5F5F5),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(imageAssetIcon),
                      ),
                    ),
                    suffixIcon: !isPassword
                        ? null
                        : InkWell(
                            onTap: showPasswordTap,
                            child: Image.asset(Assets.hidePNG)),
                  ),
            validator: (string) {
              if (string!.isEmpty) {
                return 'الرجاء ادخال البيانات';
              }
              if (string.length < 3) {
                return 'الرجاء ادخال البيانات بشكل صحيح';
              }
              if (isEmail && !string.contains('@')) {
                return 'الرجاء ادخال البيانات بشكل صحيح';
              }
              return null;
            },
            onFieldSubmitted: onFieldSubmitted,
          ),
        ),
      ],
    );
  }
}
