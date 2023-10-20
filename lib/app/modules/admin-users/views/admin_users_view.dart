import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/constants.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/choose_subscription_module.dart';
import 'package:mataajer_saudi/app/extensions/for_admin.dart';
import 'package:mataajer_saudi/app/modules/ChooseSubscription/views/choose_subscription_view.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/rounded_button.dart';
import 'package:mataajer_saudi/utils/input_format.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import '../../../data/assets.dart';
import '../../../utils/log.dart';
import '../../../widgets/back_button.dart';
import '../controllers/admin_users_controller.dart';

class AdminUsersView extends GetView<AdminUsersController> {
  const AdminUsersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: const Color(0xFFF5F5F5),
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: GetBuilder<AdminUsersController>(
          builder: (_) {
            if (controller.loading) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: MataajerTheme.loadingWidget,
              );
            }
            return Column(
              children: [
                search(),
                RoundedButton(
                  text: 'اضافة متجر',
                  press: () async {
                    await registerFunction();
                    await controller.getShops();
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        itemCount: controller.shops.length,
                        separatorBuilder: (context, index) =>
                            const Divider(thickness: 0.5),
                        itemBuilder: (context, index) {
                          return GetBuilder<AdminUsersController>(
                              id: 'shop-card-$index',
                              builder: (_) {
                                if (controller.loading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                DateTime? validTill =
                                    controller.shops[index].validTill;

                                return ListTile(
                                  onTap: () => Get.toNamed(Routes.SHOP_ACCOUNT,
                                      arguments: controller.shops[index]),
                                  onLongPress: () {},
                                  leading: CircleAvatar(
                                    radius: 22.r,
                                    backgroundImage: NetworkImage(
                                        controller.shops[index].image),
                                  ),
                                  title: Text(
                                    controller.shops[index].name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  titleAlignment: ListTileTitleAlignment.center,
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(controller.shops[index].email ?? ''),
                                      Text(controller.shops[index].phone ?? ''),
                                      Text(
                                        Constants.convertDateToDateString(
                                                validTill) ??
                                            '',
                                      ),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      controller.loading = true;
                                      controller.updateShopCard(index);

                                      await controller
                                          .deleteShop(controller.shops[index]);
                                      await controller.getShops();

                                      controller.loading = false;
                                      controller.updateShopCard(index);
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ).forAdmin,
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      title: Text('المتاجر',
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
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('اختر التصنيفات'),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        GetBuilder<AdminUsersController>(
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

  Widget search() {
    return TextField(
      onChanged: controller.search,
      style: TextStyle(
        fontSize: 13.sp,
        color: const Color.fromARGB(255, 119, 119, 119),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(right: 10.0.sp, bottom: 40.0.sp),
        prefixIcon: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Image.asset(Assets.searchIcon),
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: 30.spMin,
          minHeight: 30.spMax,
        ),
        fillColor: Colors.grey[200],
        hintText: '  ابحث عن المتاجر',
        hintStyle: TextStyle(
          fontSize: 13.sp,
          color: const Color.fromARGB(255, 119, 119, 119),
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 219, 219, 219), width: 1.0),
          borderRadius: BorderRadius.circular(30.0.r),
        ),
      ),
    );
  }

  Future registerFunction() => Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: GetBuilder<AdminUsersController>(
              id: 'add-shop-dialog',
              builder: (_) {
                if (controller.loading) {
                  return MataajerTheme.loadingWidget;
                }
                return SingleChildScrollView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                        'رقم الجوال',
                        controller.phoneController,
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
                          controller.updateAdShopDialog();
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
                      registerIsHasTamaraAndTabby(),
                      SizedBox(height: 20.h),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                        controller.updateAdShopDialog();
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
                                        controller.updateAdShopDialog();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
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
                                padding:
                                    EdgeInsets.symmetric(horizontal: 10.sp),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: TextFormField(
                                        decoration: const InputDecoration(
                                            fillColor: Colors.white),
                                        inputFormatters: numbersOnlyInputFormat,
                                        controller: controller
                                            .avgShippingPriceController,
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
                      SizedBox(height: 20.h),
                      RoundedButton(
                        text: 'تسجيل اشتراك',
                        press: () async {
                          final res = await Get.dialog(
                            ChooseSubscriptionView(),
                            barrierDismissible: false,
                          );

                          if (res['status'] == 'success') {
                            final sub = res['data'] as ChooseSubscriptionModule;
                            await controller.register(sub);
                          } else if (res['status'] == 'cancel') {
                            KSnackBar.error('عفواً لم يتم تسجيل الاشتراك');
                          } else {
                            KSnackBar.error('حدث خطأ ما');
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
        ),
        transitionCurve: Curves.easeInOut,
      );

  Widget registerIsHasTamaraAndTabby() {
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
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                controller.registerIsHasTamara =
                    !controller.registerIsHasTamara;
                controller.update();
              },
              child: Column(
                children: [
                  SizedBox(
                    width: 100.w,
                    child: Image.asset(Assets.tamaraARLogo),
                  ),
                  Checkbox(
                      value: controller.registerIsHasTamara,
                      onChanged: (v) {
                        controller.registerIsHasTamara = v!;
                        controller.update();
                      })
                ],
              ),
            ),
            InkWell(
              onTap: () {
                controller.registerIsHasTabby = !controller.registerIsHasTabby;
                controller.update();
              },
              child: Column(
                children: [
                  SizedBox(
                    width: 100.w,
                    child: Image.asset(Assets.tabbyLogo),
                  ),
                  Checkbox(
                      value: controller.registerIsHasTabby,
                      onChanged: (v) {
                        controller.registerIsHasTabby = v!;
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
}
