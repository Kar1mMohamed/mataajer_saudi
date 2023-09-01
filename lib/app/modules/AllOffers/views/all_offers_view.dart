import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/app/category_with_offers.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/data/modules/offer_module.dart';
import 'package:mataajer_saudi/app/widgets/back_button.dart';
import 'package:mataajer_saudi/app/widgets/preview_offer_dialog.dart';

import '../controllers/all_offers_controller.dart';

class AllOffersView extends GetView<AllOffersController> {
  const AllOffersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      // backgroundColor: const Color(0xFFF5F5F5),
      body: GetBuilder<AllOffersController>(builder: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: controller.categoriesWithOffers.length,
            separatorBuilder: (context, index) => SizedBox(height: 10.h),
            itemBuilder: (context, categoryIndex) {
              var categoryWithOffers =
                  controller.categoriesWithOffers[categoryIndex];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryWithOffers.category.name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: context.width,
                    height: 120.h,
                    child: offersWidget(categoryWithOffers),
                  ),
                ],
              );
            },
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
      title: Text("العروض",
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

  Widget offersWidget(CategoryWithOffers categoriesWithOffers) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, offerIndex) {
        var offer = categoriesWithOffers.offers[offerIndex];
        return _itemWidget(offer);
      },
      itemCount: categoriesWithOffers.offers.length,
      shrinkWrap: true,
    );
  }

  Widget _itemWidget(OfferModule offer) {
    if (controller.loading) {
      return Container(
        margin: EdgeInsets.only(right: 10.w),
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          image: const DecorationImage(
            image: AssetImage(Assets.loadingGIF),
            fit: BoxFit.fill,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
      );
    }
    return InkWell(
      onTap: () {
        Get.dialog(PreviewOfferDialog(offerModule: offer));
      },
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        height: 100.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          image: DecorationImage(
            image: NetworkImage(offer.imageURL),
            fit: BoxFit.fill,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
      ),
    );
  }
}
