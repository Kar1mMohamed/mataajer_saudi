import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/widgets/rounded_button.dart';

import '../../../data/assets.dart';
import '../../../theme/theme.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/drawer.dart';
import '../controllers/add_popup_ad_controller.dart';

class AddPopupAdView extends GetView<AddPopupAdController> {
  const AddPopupAdView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: const MyDrawer(shops: [], isShop: true),
      body: GetBuilder<AddPopupAdController>(builder: (_) {
        if (controller.loading) {
          return MataajerTheme.loadingWidget;
        }
        return SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 50.h),
                  Image.asset(Assets.adVector),
                  SizedBox(height: 30.h),
                  Text(
                    'اضف اعلانك وقم بترويج متجرك الالكتروني',
                    style:
                        TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'ليصل الكثير من العملاء لتحقيق نشاطك التجاري',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  _addImage(),
                  SizedBox(height: 30.h),
                  _fieldItem(
                    'ضع رابط صفحة المتجر او المنتج  ',
                    controller.shopLinkController,
                    height: 50.h,
                  ),
                  SizedBox(height: 30.h),
                  RoundedButton(
                    text: 'ارسال',
                    press: () async {
                      final isOk = await controller.addPopUpAd();
                      if (isOk) {
                        sucessDialog();
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  const Divider(thickness: 1),
                  SizedBox(height: 10.h),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      padding: EdgeInsets.symmetric(vertical: 12.w),
                      height: context.height * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.popUpAds.length,
                        itemBuilder: (context, index) => adCard(index),
                      ),
                    ),
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
      foregroundColor: Colors.white,
      elevation: 0,
      title: Text('اضافة اعلان منبثق',
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

  Widget adCard(int index) {
    final popUpAd = controller.popUpAds[index];
    return ListTile(
      onTap: () {
        controller.showPopUpAd(popUpAd);
      },
      leading: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(popUpAd.image),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(popUpAd.url ?? ''),
      subtitle:
          Text((popUpAd.isVisible ?? false) ? 'تم الموافقة' : 'جاري المراجعة'),
      trailing: IconButton(
        onPressed: () async {
          await controller.deletePopUpAd(popUpAd);
        },
        icon: const Icon(Icons.delete, color: Colors.red),
      ),
    );
  }

  Widget _addImage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'قم بارفاق صورة الاعلان',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Tajawal',
          ),
        ),
        SizedBox(height: 10.h),
        InkWell(
          onTap: () => controller.pickAndUploadImage(),
          child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                controller.imageURL != null
                    ? 'تم اضافة الصورة .. اضغط مره اخرى لتغير الصورة'
                    : 'اضف صورة',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fieldItem(
    String text,
    TextEditingController controller, {
    String? imageAssetIcon,
    void Function(String)? onFieldSubmitted,
    double? height,
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
        SizedBox(height: 10.h),
        SizedBox(
          height: height,
          child: TextFormField(
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Tajawal',
            ),
            // obscureText: isPassword ? !showPassword : false,
            obscuringCharacter: '*',
            controller: controller,
            maxLines: height != null ? 10 : 1,
            decoration: InputDecoration(
              fillColor: Colors.white,
              prefixIcon: imageAssetIcon != null
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(imageAssetIcon),
                    )
                  : null,
            ),
            validator: (string) {
              if (string!.isEmpty) {
                return 'الرجاء ادخال البيانات';
              }
              if (string.length < 3) {
                return 'الرجاء ادخال البيانات بشكل صحيح';
              }
              // if (isEmail && !string.contains('@')) {
              //   return 'الرجاء ادخال البيانات بشكل صحيح';
              // }
              return null;
            },
            onFieldSubmitted: onFieldSubmitted,
          ),
        ),
      ],
    );
  }

  Widget _button({
    required String text,
    required void Function()? onPressed,
    bool isWhiteBack = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isWhiteBack ? Colors.white : MataajerTheme.mainColor,
        padding: EdgeInsets.symmetric(
          horizontal: 20.sp,
          vertical: 10.sp,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: isWhiteBack ? const Color(0xFF626262) : Colors.white,
        ),
      ),
    );
  }

  void sucessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Assets.adAddedVector,
                  filterQuality: FilterQuality.high),
              SizedBox(height: 10.h),
              Text(
                'تم رفع الطلب بنجاح',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'جاري المتابعة...',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10.h),
              _button(
                text: 'الرجوع للصفحة الرئيسية',
                onPressed: () {
                  Get.back();
                  Get.back();
                },
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
