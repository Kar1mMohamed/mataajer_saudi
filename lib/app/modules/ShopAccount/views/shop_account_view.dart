import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
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
      backgroundColor: Colors.white,
      appBar: appBar(),
      drawer: MyDrawer(shops: const [], isShop: controller.isShop),
      body: GetBuilder<ShopAccountController>(builder: (_) {
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
                    value: controller.showShop,
                    onChanged: (v) {
                      controller.showShop = v;
                      controller.update();
                    },
                    activeColor: Color(0xFF4CAF50),
                    thumbColor: Color(0xFFE8F5E9),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  'اضهار المتجر',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Color(0xFF5E5E5E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
                _fieldItem('اسم المتجر', controller.shopNameController),
                SizedBox(height: 20.h),
                _fieldItem('البريد الالكتروني', controller.emailController,
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
                _fieldItem(
                  'كلمات مفتاحية',
                  controller.shopKeyWordsController,
                ),
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
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButton(
                                  hint: Text(
                                    'من',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontFamily: 'Tajawal',
                                        fontWeight: FontWeight.w400),
                                  ),
                                  underline: Container(),
                                  value: controller.shippingFrom,
                                  items: List.generate(
                                    5,
                                    (index) {
                                      final value = index + 1;

                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(
                                          value.toString(),
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.w400),
                                        ),
                                      );
                                    },
                                  ),
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
                                  color: const Color(0xFFF5F5F5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButton(
                                  hint: Text(
                                    'الي',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontFamily: 'Tajawal',
                                        fontWeight: FontWeight.w400),
                                  ),
                                  underline: Container(),
                                  value: controller.shippingTo,
                                  items: List.generate(5, (index) {
                                    final value = index + 1;
                                    return DropdownMenuItem(
                                      value: value,
                                      child: Text(
                                        value.toString(),
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontFamily: 'Tajawal',
                                            fontWeight: FontWeight.w400),
                                      ),
                                    );
                                  }),
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
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    inputFormatters: numbersOnlyInputFormat,
                                    controller:
                                        controller.avgShippingPriceController,
                                    onChanged: (v) {},
                                  ),
                                ),
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
                SizedBox(height: 20.h),
                RoundedButton(
                  text: 'حفظ',
                  press: () => {},
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget shopImage() {
    return Container(
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
          image: NetworkImage(
              'https://mir-s3-cdn-cf.behance.net/projects/404/1cb86469753415.Y3JvcCwxMTUwLDg5OSwxMzc1LDY0Mw.jpg'),
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
              Color.fromARGB(255, 0, 0, 0).withOpacity(0.01),
              Color.fromARGB(255, 0, 0, 0),
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
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
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
                      print('categories: ${controller.choosedCategories}');
                    },
                  ),
                ),
              );
            }),
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
}