import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:mataajer_saudi/app/widgets/back_button.dart';
import 'package:mataajer_saudi/app/widgets/drawer.dart';
import 'package:mataajer_saudi/app/widgets/rounded_button.dart';
import 'package:mataajer_saudi/utils/input_format.dart';

import '../controllers/shop_account_controller.dart';

class ShopAccountView extends GetView<ShopAccountController> {
  const ShopAccountView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: MyDrawer(shops: const [], isShop: controller.isShop),
      body: GetBuilder<ShopAccountController>(builder: (_) {
        if (controller.loading) {
          return MataajerTheme.loadingWidget;
        }
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(child: shopImage()),
                SizedBox(height: 15.h),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: CupertinoSwitch(
                    value: controller.isVisible,
                    onChanged: (v) {
                      controller.isVisible = v;
                      controller.update();
                    },
                    activeColor: const Color(0xFF4CAF50),
                    thumbColor: const Color(0xFFE8F5E9),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'اضهار المتجر',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF5E5E5E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
                _fieldItem('اسم المتجر', controller.shopNameController),
                SizedBox(height: 20.h),
                _fieldItem('البريد الالكتروني', controller.emailController,
                    isEmail: true, imageAssetIcon: Assets.emailPNG),
                SizedBox(height: 20.h),
                _fieldItem('رقم الجوال', controller.phoneController,
                    isEmail: true, imageAssetIcon: Assets.emailPNG),
                SizedBox(height: 20.h),
                _fieldItem('رابط المتجر', controller.shopLinkController,
                    imageAssetIcon: Assets.marketVectorPNG),
                SizedBox(height: 20.h),
                chooseCategory(),
                SizedBox(height: 20.h),
                _fieldItem(
                  'وصف المتجر',
                  controller.shopDescriptionController,
                  height: 100.h,
                ),
                SizedBox(height: 20.h),
                _fieldItem('كلمات مفتاحية', controller.shopKeyWordsController),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 80.h,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'متوسط مدة الشحن',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 10.sp),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButton(
                                  hint: Text(
                                    'من',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  underline: Container(),
                                  value: controller.shippingFrom,
                                  items: controller.shippingTimes
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e.toString(),
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontFamily: 'Tajawal',
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) {
                                    controller.shippingFrom = v;
                                    controller.update();
                                  },
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Container(
                                padding:
                                    EdgeInsets.symmetric(horizontal: 10.sp),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButton(
                                  hint: Text(
                                    'الي',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontFamily: 'Tajawal',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  underline: Container(),
                                  value: controller.shippingTo,
                                  items: controller.shippingTimes
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e.toString(),
                                            style: TextStyle(
                                                fontSize: 13.sp,
                                                fontFamily: 'Tajawal',
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) {
                                    controller.shippingTo = v;
                                    controller.update();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // SizedBox(width: 20.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'متوسط سعر الشحن',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            width: 150.w,
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
                            child: Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                        fillColor: Colors.white),
                                    inputFormatters: numbersOnlyInputFormat,
                                    controller:
                                        controller.avgShippingPriceController,
                                    onChanged: (v) {},
                                  ),
                                ),
                                SizedBox(width: 5.w),
                                const Text('ريال سعودي'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                _fieldItem(
                  'اضافة كود خصم',
                  controller.cuponCodeController,
                ),
                SizedBox(height: 20.h),
                _fieldItem(
                  'تفاصيل كود خصم',
                  controller.cuponCodeDetailsController,
                  height: 80.h,
                ),
                _fieldItem(
                  'رابط الفيسبوك',
                  controller.facebookController,
                ),
                SizedBox(height: 20.h),
                _fieldItem(
                  'رابط الانستقرام',
                  controller.instagramController,
                ),
                SizedBox(height: 20.h),
                _fieldItem(
                  'رابط السناب شات',
                  controller.snapchatController,
                ),
                SizedBox(height: 20.h),
                _fieldItem(
                  'رابط تويتر',
                  controller.twitterController,
                ),
                SizedBox(height: 20.h),
                _fieldItem(
                  'رابط اليوتيوب',
                  controller.youtubeController,
                ),
                SizedBox(height: 20.h),
                SizedBox(height: 20.h),
                isHasTamaraAndTabby(),
                SizedBox(height: 20.h),
                RoundedButton(
                  text: 'حفظ',
                  press: () async {
                    log('save shop');
                    await controller.updateShop();
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget shopImage() {
    return InkWell(
      onTap: () => controller.updateProfileImage(),
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(360),
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.center,
            colors: [
              Color(0xffF9F9F9),
              Color.fromARGB(255, 0, 0, 0),
            ],
          ),
          image: DecorationImage(
            image: NetworkImage(controller.currentShop!.image),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color.fromARGB(255, 0, 0, 0).withOpacity(0.01),
                const Color.fromARGB(255, 0, 0, 0),
              ],
            ),
            borderRadius: BorderRadius.circular(360),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.camera_alt,
                size: 30.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget chooseCategory() {
    return Column(
      children: [
        InkWell(
          onTap: () => controller.updateShowCategories(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 20.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('التصنيفات'),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        GetBuilder<ShopAccountController>(
            id: 'showCategories',
            builder: (_) {
              return Visibility(
                visible: controller.showCategories,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 20.sp),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: MultiSelectContainer<CategoryModule>(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    textStyles: MultiSelectTextStyles(
                      selectedTextStyle: TextStyle(
                        color: const Color(0xFF5E5E5E),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      textStyle: TextStyle(
                        color: const Color(0xFF5E5E5E),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    itemsDecoration: const MultiSelectDecorations(
                      selectedDecoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                    prefix: MultiSelectPrefix(
                      enabledPrefix: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey, width: 0.5),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      selectedPrefix: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: MataajerTheme.mainColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey, width: 0.5),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      // disabledPrefix: const Padding(
                      //   padding: EdgeInsets.only(right: 5),
                      //   child: Icon(
                      //     Icons.do_disturb_alt_sharp,
                      //     size: 14,
                      //   ),
                      // ),
                    ),
                    items: controller.categoriesList
                        .map(
                          (e) => MultiSelectCard(
                            selected: controller.choosedCategories.contains(e),
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChange: (allSelectedItems, selectedItem) {
                      controller.choosedCategories = allSelectedItems;
                      controller.update();
                      log('categories: ${controller.choosedCategories}');
                    },
                  ),
                ),
              );
            }),
      ],
    );
  }

  Widget isHasTamaraAndTabby() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'هل انت مشترك في احدهم ؟',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                controller.isHasTamara = !controller.isHasTamara;
                controller.update();
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 100.h,
                    width: 150.w,
                    child: Image.asset(Assets.tamaraARLogo),
                  ),
                  Checkbox(
                      value: controller.isHasTamara,
                      onChanged: (v) {
                        controller.isHasTamara = v!;
                        controller.update();
                      })
                ],
              ),
            ),
            InkWell(
              onTap: () {
                controller.isHasTabby = !controller.isHasTabby;
                controller.update();
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 100.h,
                    width: 150.w,
                    child: Image.asset(Assets.tabbyLogo),
                  ),
                  Checkbox(
                      value: controller.isHasTabby,
                      onChanged: (v) {
                        controller.isHasTabby = v!;
                        controller.update();
                      })
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      title: Text('حسابي',
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
        SizedBox(height: 5.h),
        SizedBox(
          height: height,
          child: TextFormField(
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Tajawal',
            ),
            obscureText: isPassword ? !showPassword : false,
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

  // Widget _button({
  //   required String text,
  //   required void Function()? onPressed,
  //   bool isWhiteBack = false,
  // }) {
  //   return ElevatedButton(
  //     onPressed: onPressed,
  //     style: ElevatedButton.styleFrom(
  //       backgroundColor: isWhiteBack ? Colors.white : MataajerTheme.mainColor,
  //       padding: EdgeInsets.symmetric(
  //         horizontal: 20.sp,
  //         vertical: 10.sp,
  //       ),
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //     ),
  //     child: Text(
  //       text,
  //       style: TextStyle(
  //         fontFamily: 'Tajawal',
  //         fontSize: 13.sp,
  //         fontWeight: FontWeight.w500,
  //         color: isWhiteBack ? const Color(0xFF626262) : Colors.white,
  //       ),
  //     ),
  //   );
  // }
}
