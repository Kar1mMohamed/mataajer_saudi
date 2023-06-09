import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/choose_subscription_module.dart';
import 'package:mataajer_saudi/app/modules/ChooseSubscription/views/choose_subscription_view.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/loading_image.dart';
import 'package:mataajer_saudi/app/widgets/rounded_button.dart';
import 'package:mataajer_saudi/utils/input_format.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import '../controllers/shop_login_and_register_controller.dart';

class ShopLoginAndRegisterView extends GetView<ShopLoginAndRegisterController> {
  const ShopLoginAndRegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MataajerTheme.mainColor,
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return SizedBox(
      height: context.height,
      width: double.infinity,
      child: Stack(
        // alignment: AlignmentDirectional.topCenter,
        children: [
          SizedBox(height: 15.h),
          _header(),
          _body(context),
        ],
      ),
    );
  }

  Widget _header() {
    return SizedBox(
      height: 280.h,
      width: double.infinity,
      child: Container(
        decoration: const BoxDecoration(
          color: MataajerTheme.mainColor,
          image: DecorationImage(
            image: AssetImage(Assets.loginRegisterImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'متاجر السعودية',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  GetBuilder<ShopLoginAndRegisterController>(
                      id: 'subTitle',
                      builder: (_) {
                        return Text(
                          controller.subTitles[controller.pageIndex],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return GetBuilder<ShopLoginAndRegisterController>(builder: (_) {
      return SizedBox(
        height: context.height,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: context.height * 0.24),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(45),
              topRight: Radius.circular(45),
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  width: double.infinity,
                  child: Column(
                    children: [
                      SizedBox(height: 35.h),
                      Row(
                        children: [
                          _button(
                            text: "تسجيل دخول",
                            onPressed: () => controller.changePageIndex(0),
                            isWhiteBack: controller.pageIndex != 0,
                          ),
                          SizedBox(width: 5.w),
                          _button(
                            text: "تسجيل اشتراك",
                            onPressed: () => controller.changePageIndex(1),
                            isWhiteBack: controller.pageIndex == 0,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Flexible(
                        child: PageView(
                          onPageChanged: controller.changePageIndex,
                          controller: controller.pageController,
                          children: [
                            login(context),
                            register(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget login(BuildContext context) {
    if (controller.loading) {
      return MataajerTheme.loadingWidget;
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          _fieldItem(
            'البريد الالكتروني',
            controller.loginEmailController,
            imageAssetIcon: Assets.emailPNG,
          ),
          SizedBox(height: 20.h),
          _fieldItem('كلمة المرور', controller.loginPasswordController,
              imageAssetIcon: Assets.passwordPNG,
              isPassword: true,
              showPassword: controller.showPassword, showPasswordTap: () {
            controller.showPassword = !controller.showPassword;
            controller.update();
          }),
          SizedBox(height: 10.h),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                const Text(
                  'هل نسيت كلمة المرور؟',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF626262),
                  ),
                ),
                SizedBox(width: 5.w),
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.RESET_PASSWORD,
                        arguments: {'isEmailVerify': true});
                  },
                  child: const Text(
                    'استعدها',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: MataajerTheme.mainColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          RoundedButton(
            text: 'تسجيل الدخول',
            press: () => controller.login(),
            radius: 12,
          ),
        ],
      ),
    );
  }

  Widget register(BuildContext context) {
    if (controller.loading) {
      return MataajerTheme.loadingWidget;
    }
    return SingleChildScrollView(
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            SizedBox(height: 20.h),
            regitserImage(),
            SizedBox(height: 30.h),
            _fieldItem(
              'اسم المتجر',
              controller.shopNameController,
            ),
            SizedBox(height: 20.h),
            _fieldItem(
              'البريد الالكتروني',
              controller.emailController,
              imageAssetIcon: Assets.emailPNG,
            ),
            SizedBox(height: 20.h),
            _fieldItem(
              'كلمة المرور',
              controller.passwordController,
              imageAssetIcon: Assets.passwordPNG,
              isPassword: true,
              showPassword: controller.showPassword,
              showPasswordTap: () {
                controller.showPassword = !controller.showPassword;
                controller.update();
              },
            ),
            SizedBox(height: 20.h),
            _fieldItem(
              'رابط المتجر',
              controller.shopLinkController,
              imageAssetIcon: Assets.marketVectorPNG,
            ),
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
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
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
                                10,
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
                            padding: EdgeInsets.symmetric(horizontal: 10.sp),
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
                              items: List.generate(10, (index) {
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
            pricesTable(),
            SizedBox(height: 40.h),
            RoundedButton(
              text: 'تسجيل اشتراك',
              // press: () => controller.register(),
              press: () async {
                final res = await Get.dialog(
                  ChooseSubscriptionView(),
                  barrierDismissible: false,
                );

                if (res['status'] == 'success') {
                  final sub = res['data'] as ChooseSubscriptionModule;
                  controller.register(sub);
                } else if (res['status'] == 'cancel') {
                  KSnackBar.error('عفواً لم يتم تسجيل الاشتراك');
                } else {
                  KSnackBar.error('حدث خطأ ما');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget regitserImage() {
    if (controller.shopImageURL == null) {
      return Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(360),
          border: Border.all(color: const Color(0xFFA9A9A9), width: 1),
        ),
        child: InkWell(
          onTap: () => controller.pickImageAndUpload(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Assets.imageVectorPNG),
                SizedBox(height: 5.h),
                Text(
                  'اضف شعار المتجر',
                  style: TextStyle(
                    color: const Color(0xFFA9A9A9),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 120,
        width: 120,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(120.r),
            child: LoadingImage(src: controller.shopImageURL)),
      );
    }
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
                Text('اختر التصنيفات'),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        GetBuilder<ShopLoginAndRegisterController>(
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

  Widget pricesTable() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.sp),
          decoration: const BoxDecoration(
            color: Color(0xFF787878),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  controller.showPricesTable = !controller.showPricesTable;
                  controller.update();
                },
                child: Row(
                  children: [
                    Text(
                      'اختر',
                      style: _pricesHeaderTextStyle(),
                    ),
                    Icon(Icons.arrow_drop_down,
                        color: Colors.white, size: 30.sp),
                  ],
                ),
              ),
              Row(
                children: [
                  Text('الباقة العادية', style: _pricesHeaderTextStyle()),
                  SizedBox(width: Get.context!.isTablet ? 50.w : 30.w),
                  Text('الباقة الفضية', style: _pricesHeaderTextStyle()),
                  SizedBox(width: Get.context!.isTablet ? 50.w : 30.w),
                  Text('الباقة الذهبية', style: _pricesHeaderTextStyle()),
                  SizedBox(width: Get.context!.isTablet ? 20.w : 10.w),
                ],
              ),
            ],
          ),
        ),
        Visibility(
          visible: controller.showPricesTable,
          child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
                decoration: const BoxDecoration(
                  color: MataajerTheme.mainColorLighten,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('المزايا',
                        style: _pricesHeaderTextStyle(fontSize: 14.sp)),
                    Row(
                      children: [
                        _priceText(controller.pricesFromSubscriptions[0]),
                        SizedBox(width: Get.context!.isTablet ? 56.w : 50.w),
                        _priceText(controller.pricesFromSubscriptions[1]),
                        SizedBox(width: Get.context!.isTablet ? 56.w : 50.w),
                        _priceText(controller.pricesFromSubscriptions[2]),
                        SizedBox(width: Get.context!.isTablet ? 20.w : 10.w),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    _pricesDetailsRow('نشر الموقع', true, true, true),
                    _pricesDetailsRow('تثبيت الموقع ', false, true, true,
                        isWhite: true),
                    _pricesDetailsRow('2اعلان منبثق شهريا', false, true, true),
                    _pricesDetailsRow('4اعلان منبثق شهريا', false, false, true,
                        isWhite: true),
                    _pricesDetailsRow('ارسال اشعارات', false, false, true),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _priceText(double yearPrice) {
    return InkWell(
      onTap: () {
        print('year price: $yearPrice');
      },
      child: Text(
        '$yearPrice ريال',
        style: _pricesHeaderTextStyle(
          weight: FontWeight.w500,
          fontSize: 12.sp,
        ),
      ),
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

  TextStyle _pricesHeaderTextStyle(
          {double? fontSize, Color? color, FontWeight? weight}) =>
      TextStyle(
        fontSize: fontSize ?? 12,
        fontWeight: weight ?? FontWeight.w500,
        fontFamily: 'Tajawal',
        color: color ?? Colors.white,
      );

  Widget _pricesDetailsRow(
      String title, bool firstRight, bool secondRight, bool thirdRgiht,
      {bool? isWhite}) {
    const fontColor = Colors.black;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 15.sp),
      color: isWhite ?? false ? Colors.white : Color(0xFFEFEFEF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: _pricesHeaderTextStyle(
                fontSize: 12.sp,
                color: fontColor,
              ),
            ),
          ),
          Row(
            children: [
              firstRight
                  ? Image.asset(Assets.rightCheck2PNG,
                      filterQuality: FilterQuality.high)
                  : Image.asset(Assets.wrongCheck2PNG,
                      filterQuality: FilterQuality.high),
              SizedBox(width: 65.w),
              secondRight
                  ? Image.asset(Assets.rightCheck2PNG,
                      filterQuality: FilterQuality.high)
                  : Image.asset(Assets.wrongCheck2PNG,
                      filterQuality: FilterQuality.high),
              SizedBox(width: 65.w),
              thirdRgiht
                  ? Image.asset(Assets.rightCheck2PNG,
                      filterQuality: FilterQuality.high)
                  : Image.asset(Assets.wrongCheck2PNG,
                      filterQuality: FilterQuality.high),
            ],
          ).paddingOnly(left: 30.w),
        ],
      ),
    );
  }
}
