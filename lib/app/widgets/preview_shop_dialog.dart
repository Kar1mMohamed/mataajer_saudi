import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/preview_dialog_controller.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';

class PreviewShopDialog extends StatelessWidget {
  const PreviewShopDialog({super.key, required this.ad});
  final AdModule ad;

  @override
  Widget build(BuildContext context) {
    PreviewDialogController controller =
        Get.put(PreviewDialogController(adUID: ad.uid!));
    return GetBuilder<PreviewDialogController>(builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 35.h),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 90.h,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: MataajerTheme.mainColorLighten),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 75,
                          width: 75,
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(48),
                              child: Image.network(
                                ad.imageURL,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ad.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              ad.categories.first.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0.sp),
                            child: Text(
                              'عدد الزيارات  ${ad.hits ?? 0}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'وصف المتجر',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.0.h),
                      Text(
                        ad.description,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            'متوسط سعر \n الشحن',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12.0.sp, fontWeight: FontWeight.w500),
                          ),
                          Container(
                            padding: const EdgeInsets.all(25.0),
                            decoration: const BoxDecoration(
                              color: MataajerTheme.mainColor,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${ad.avgShippingPrice}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'ريال',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 40.w),
                      Column(
                        children: [
                          Text(
                            'متوسط مدة \n الشحن',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12.0.sp, fontWeight: FontWeight.w500),
                          ),
                          Container(
                            padding: const EdgeInsets.all(25.0),
                            decoration: const BoxDecoration(
                              color: MataajerTheme.mainColor,
                              shape: BoxShape.circle,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '${ad.avgShippingTime}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'ايام',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 35.h,
                        width: Get.context!.width * 0.3,
                        decoration: const BoxDecoration(
                          color: MataajerTheme.mainColorLighten,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'نسخ الكود',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 35.h,
                        width: Get.context!.width * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'خصم 20% على جميع المنتجات',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'متاجر مشابهة',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: Get.context!.height * 0.18,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => InkWell(
                        focusColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.back();
                          Get.dialog(PreviewShopDialog(ad: ad));
                        },
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50.r),
                              child: Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/mataajer-saudi.appspot.com/o/%D8%A7%D9%84%D9%88%D8%A7%D8%AF%D9%8A.jpg?alt=media&token=29 af9bc2-953f-48e5-a5ce-65a0ceeacdda',
                                height: 75.h,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            const Text('متجر مشابه'),
                          ],
                        ),
                      ),
                      separatorBuilder: (context, index) =>
                          SizedBox(width: 20.w),
                      itemCount: 5,
                      shrinkWrap: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
