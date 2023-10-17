import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/widgets/back_button.dart';
import 'package:mataajer_saudi/app/widgets/rounded_button.dart';
import 'package:mataajer_saudi/utils/input_format.dart';
import '../../../data/assets.dart';
import '../../../theme/theme.dart';
import '../../../widgets/drawer.dart';
import '../controllers/add_offer_controller.dart';

class AddOfferView extends GetView<AddOfferController> {
  const AddOfferView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: const MyDrawer(shops: []),
      body: GetBuilder<AddOfferController>(builder: (_) {
        if (controller.loading) {
          return MataajerTheme.loadingWidget;
        }
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50.h),
                  Image.asset(Assets.adVector),
                  SizedBox(height: 30.h),
                  Text(
                    'اضف عرضك وقم بترويج متجرك الالكتروني',
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
                    'اسم المنتج او الخدمة',
                    controller.offerName,
                    height: 50.h,
                  ),
                  SizedBox(height: 30.h),
                  _fieldItem(
                    'وصف المنتج او الخدمة',
                    controller.offerDescription,
                    height: 50.h,
                  ),
                  SizedBox(height: 30.h),
                  _fieldItem(
                    'ضع رابط الخدمة او المنتج  ',
                    controller.shopLinkController,
                    height: 50.h,
                  ),

                  SizedBox(height: 30.h),

                  _fieldItem(
                    'السعر الاصلي',
                    controller.beforePrice,
                    height: 50.h,
                    isNumbersOnly: true,
                  ),
                  SizedBox(height: 30.h),
                  _fieldItem('نسبة الخصم', controller.offerPercentage,
                      height: 50.h, isNumbersOnly: true, onChanged: (v) {
                    if (controller.beforePrice.text.isEmpty) {
                      return;
                    }
                    if (v.isNotEmpty && v.isNumericOnly) {
                      controller.afterPrice.text =
                          (double.parse(controller.beforePrice.text) -
                                  (double.parse(controller.beforePrice.text) *
                                      (double.parse(
                                              controller.offerPercentage.text) /
                                          100)))
                              .toString();

                      controller.update();
                    }
                  }),
                  SizedBox(height: 30.h),

                  _fieldItem(
                    'السعر بعد الخصم',
                    controller.afterPrice,
                    height: 50.h,
                    isNumbersOnly: true,
                    readOnly: true,
                  ),
                  SizedBox(height: 30.h),

                  // _fieldItem(
                  //   'تفاصيل الخصم',
                  //   controller.cuponCodeDescription,
                  //   height: 50.h,
                  // ),
                  // SizedBox(height: 30.h),
                  chooseDuration(),
                  SizedBox(height: 30.h),
                  RoundedButton(
                    text: 'ارسال',
                    press: () async {
                      final isOk = await controller.addOffer();
                      if (isOk) {
                        sucessDialog();
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  const Divider(thickness: 1),
                  SizedBox(height: 10.h),
                  Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    padding: EdgeInsets.symmetric(vertical: 12.w),
                    height: context.height * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.offers.length,
                        itemBuilder: (context, index) {
                          final offer = controller.offers[index];
                          return ListTile(
                            onTap: () {
                              controller.showOffer(offer);
                            },
                            leading: Container(
                              width: 50.w,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(offer.imageURL),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(offer.name),
                            subtitle: Text((offer.isVisible ?? false)
                                ? 'تم الموافقة'
                                : 'جاري المراجعة'),
                            trailing: IconButton(
                              onPressed: () async {
                                await controller.deleteOffer(offer);
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                            ),
                          );
                        }),
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
      title: Text('اضافة عرض',
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
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
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
    void Function(String)? onChanged,
    double? height,
    bool? isNumbersOnly,
    bool readOnly = false,
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
            readOnly: readOnly,
            onChanged: onChanged,

            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Tajawal',
            ),
            // obscureText: isPassword ? !showPassword : false,
            obscuringCharacter: '*',
            controller: controller,
            maxLines: height != null ? 10 : 1,
            inputFormatters: (isNumbersOnly != null && isNumbersOnly == true)
                ? numbersOnlyWithPrecisionInputFormat
                : null,

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

  Widget chooseDuration() {
    return Column(
      children: [
        Text(
          'اختر مدة العرض',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Tajawal',
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<int>(
                value: controller.chooseDuration,
                underline: Container(),
                items: List.generate(
                  100,
                  (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text(
                      '${index + 1}',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                  ),
                ),
                onChanged: (value) {
                  controller.chooseDuration = value!;
                  controller.update();
                },
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'يوم',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Tajawal',
              ),
            ),
          ],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     _button(
        //       text: 'يوم',
        //       onPressed: () {
        //         controller.chooseDuration = 1;
        //         controller.update();
        //       },
        //       isClicked: controller.chooseDuration == 1,
        //     ),
        //     _button(
        //       text: 'ثلاثة ايام',
        //       onPressed: () {
        //         controller.chooseDuration = 3;
        //         controller.update();
        //       },
        //       isClicked: controller.chooseDuration == 3,
        //     ),
        //     _button(
        //       text: 'اسبوع',
        //       onPressed: () {
        //         controller.chooseDuration = 7;
        //         controller.update();
        //       },
        //       isClicked: controller.chooseDuration == 7,
        //     ),
        //     _button(
        //       text: 'شهر',
        //       onPressed: () {
        //         controller.chooseDuration = 30;
        //         controller.update();
        //       },
        //       isClicked: controller.chooseDuration == 30,
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget _button({
    required String text,
    required void Function()? onPressed,
    bool isClicked = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isClicked
            ? const Color.fromARGB(255, 111, 71, 130)
            : MataajerTheme.mainColor,
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
          color: Colors.white,
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
