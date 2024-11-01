import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/preview_shop_dialog_controller.dart';
import 'package:mataajer_saudi/app/data/modules/offer_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/url_launcher.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:mataajer_saudi/app/widgets/preview_offer_dialog.dart';

import '../data/assets.dart';

class PreviewShopDialog extends StatelessWidget {
  const PreviewShopDialog({super.key, required this.shop});
  final ShopModule shop;

  @override
  Widget build(BuildContext context) {
    PreviewShopDialogController controller =
        Get.put(PreviewShopDialogController(shopModule: shop));
    return GetBuilder<PreviewShopDialogController>(builder: (context) {
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
                                shop.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              shop.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              shop.categories.first.name,
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
                              'عدد الزيارات  ${shop.hits ?? 0}',
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
                        shop.description,
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
                                  '${shop.avgShippingPrice}',
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
                                  '${shop.avgShippingTime}',
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
                InkWell(
                  onTap: () {
                    // set clippboard
                    Clipboard.setData(
                        ClipboardData(text: shop.cuponCode ?? ''));
                    Get.snackbar(
                      'نسخ الكود',
                      'تم نسخ الكود بنجاح',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
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
                                shop.cuponText ?? '',
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
                socailMediaSection(),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    if (shop.isHasTamara ?? false)
                      SizedBox(
                        height: 100.h,
                        width: 150.w,
                        child: Image.asset(Assets.tamaraARLogo),
                      ),
                    if (shop.isHasTabby ?? false)
                      SizedBox(
                        height: 100.h,
                        width: 150.w,
                        child: Image.asset(Assets.tabbyLogo),
                      )
                  ],
                ),
                SizedBox(height: 20.h),
                if (controller.allOffers.isNotEmpty) allOffers(),
                if (controller.similarShops.isNotEmpty) similarShops(),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget similarShops() {
    final controller = Get.find<PreviewShopDialogController>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'متاجر مشابهة',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
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
                  _similarAdCard(controller.similarShops[index]),
              separatorBuilder: (context, index) => SizedBox(width: 20.w),
              itemCount: controller.similarShops.length,
              shrinkWrap: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget allOffers() {
    final controller = Get.find<PreviewShopDialogController>();
    log('showing all offers ${controller.allOffers.length}');
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              'عروض المتجر',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
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
                  _offerCard(controller.allOffers[index]),
              separatorBuilder: (context, index) => SizedBox(width: 20.w),
              itemCount: controller.allOffers.length,
              shrinkWrap: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _similarAdCard(ShopModule shop) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Get.back(closeOverlays: true);
        Get.dialog(PreviewShopDialog(shop: shop),
            barrierColor: Colors.transparent);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundImage: NetworkImage(
              shop.image,
              // height: 75,
              // width: 75,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            shop.name,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _offerCard(OfferModule offer) {
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Get.dialog(PreviewOfferDialog(offerModule: offer),
            barrierColor: Colors.transparent);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundImage: NetworkImage(
              offer.imageURL,
              // height: 75,
              // width: 75,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            offer.name,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: '${offer.priceBefore?.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.lineThrough,
                    fontSize: 12.sp,
                  ),
                ),
                TextSpan(
                  text: ' ${offer.priceAfter?.toStringAsFixed(2)} ر.س',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: MataajerTheme.mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget socailMediaSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _socailMediaItem(shop.socialMediaLinks?.facebook, Assets.facebookSVG),
          _socailMediaItem(shop.socialMediaLinks?.twitter, Assets.twitterSVG),
          _socailMediaItem(
              shop.socialMediaLinks?.instagram, Assets.instagramSVG),
          _socailMediaItem(shop.socialMediaLinks?.snapchat, Assets.snapchatSVG),
          _socailMediaItem(shop.socialMediaLinks?.youtube, Assets.youtubeSVG),
          _socailMediaItem(shop.socialMediaLinks?.tiktok, Assets.tiktokSVG),
          _socailMediaItem(shop.socialMediaLinks?.linkedin, Assets.linkedinSVG),
        ],
      ),
    );
  }

  Widget _socailMediaItem(String? url, String svgAsset) {
    if (url == null) return const SizedBox.shrink();
    return InkWell(
      onTap: () {
        URLLauncherFuntions.launchURL(url);
      },
      child: SvgPicture.asset(
        svgAsset,
        height: 40.h,
        width: 40.w,
      ),
    );
  }
}
