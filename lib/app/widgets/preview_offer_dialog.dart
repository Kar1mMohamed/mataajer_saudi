import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/preview_ad_dialog_controller.dart';
import 'package:mataajer_saudi/app/data/modules/offer_module.dart';
import 'package:mataajer_saudi/app/functions/url_launcher.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/utils/custom_snackbar.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class PreviewOfferDialog extends StatelessWidget {
  const PreviewOfferDialog({super.key, required this.offerModule});
  final OfferModule offerModule;

  @override
  Widget build(BuildContext context) {
    PreviewOfferDialogController controller =
        Get.put(PreviewOfferDialogController(offerModule: offerModule));
    return GetBuilder<PreviewOfferDialogController>(builder: (context) {
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
                  decoration: BoxDecoration(
                    color: MataajerTheme.mainColorLighten,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                    ),
                  ),
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
                                offerModule.imageURL,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                offerModule.name.trim(),
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Text(
                              offerModule.categories.first.name,
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
                              'عدد الزيارات  ${offerModule.hits ?? 0}',
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
                        'اسم المنتج',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.0.h),
                      Text(
                        offerModule.name.trim(),
                        maxLines: 1,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
                        'وصف العرض',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 5.0.h),
                      Text(
                        '${offerModule.offerDescription}',
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
                                  '${offerModule.avgShippingPrice}',
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
                                  '${offerModule.avgShippingTime}',
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
                      SizedBox(width: 40.w),
                      Column(
                        children: [
                          Text(
                            'مدة العرض',
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
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${offerModule.toDate!.difference(offerModule.fromDate!).inDays + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  offerModule.toDate!
                                                  .difference(
                                                      offerModule.fromDate!)
                                                  .inDays +
                                              1 >
                                          1
                                      ? 'ايام'
                                      : 'يوم',
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
                InkWell(
                  onTap: () {
                    // // set clippboard
                    // Clipboard.setData(
                    //     ClipboardData(text: offerModule.offerPercentage ?? ''));
                    // Get.snackbar(
                    //   'نسخ الكود',
                    //   'تم نسخ الكود بنجاح',
                    //   snackPosition: SnackPosition.TOP,
                    //   backgroundColor: Colors.green,
                    //   colorText: Colors.white,
                    // );

                    try {
                      URLLauncherFuntions.launchURL(offerModule.offerLink!);
                    } catch (e) {
                      CustomSnackBar.error('عفواً لا يمكن فتح الرابط');
                      log('PreviewOfferDialog: $e');
                    }
                  },
                  child: Padding(
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
                                'الذهاب للمتجر',
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
                                'نسبة الخصم ${offerModule.offerPercentage} %',
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
                ),
                SizedBox(height: 20.h),
                if (controller.similarAds.isNotEmpty)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'عروض مشابهة',
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
                            itemBuilder: (context, index) =>
                                _similarAdCard(controller.similarAds[index]),
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 20.w),
                            itemCount: controller.similarAds.length,
                            shrinkWrap: true,
                          ),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _similarAdCard(OfferModule ad) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Get.back(closeOverlays: false);
        Get.dialog(PreviewOfferDialog(offerModule: ad));
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundImage: NetworkImage(
              ad.imageURL,
              // height: 75,
              // width: 75,
            ),
          ),
          SizedBox(height: 10.h),
          Flexible(
            child: Text(
              ad.name.trim(),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
