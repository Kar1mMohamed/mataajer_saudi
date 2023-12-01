import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/loading_image.dart';
import 'package:mataajer_saudi/app/widgets/rounded_button.dart';

import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CartController>(
        builder: (_) {
          return controller.localCart.isEmpty
              ? SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 150,
                        color: Colors.grey.shade300,
                      ),
                      Text(
                        "No items in your Cart".tr,
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: Colors.grey.shade300,
                        ),
                      )
                    ],
                  ),
                )
              : SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      _header(),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                clipBehavior: Clip.antiAlias,
                                child: _orderCard(index),
                              );
                            },
                            itemCount: controller.localCart.length,
                          ),
                        ),
                      ),
                      RoundedButton(text: 'شراء', press: () {})
                    ],
                  ),
                );
        },
      ),
    );
  }

  Widget _header() => Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          right: 30.sp,
          left: 30.sp,
          bottom: 10.sp,
        ),
        decoration: BoxDecoration(
          color: MataajerTheme.mainColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.r),
            bottomRight: Radius.circular(20.r),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 0),
              blurRadius: 5,
              spreadRadius: 2,
            )
          ],
        ),
        child: SafeArea(
          child: Text(
            "العربة".tr,
            textAlign: TextAlign.center,
            style: MataajerTheme.mainTextStyle.copyWith(
              fontSize: 25.sp,
              fontWeight: FontWeight.bold,
              height: 2,
              letterSpacing: 0.8,
              color: Colors.white,
            ),
          ),
        ),
      );

  Widget _orderCard(int index) {
    return Container(
      padding: const EdgeInsets.all(5),
      height: 120.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.02),
            offset: const Offset(0, 0),
            blurRadius: 5,
            spreadRadius: 2,
          )
        ],
      ),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 120.h,
                  width: 130.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    clipBehavior: Clip.antiAlias,
                    child: LoadingImage(
                      src: controller.localCart[index].itemModel.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                CloseButton(
                  onPressed: () {
                    controller.removeItemFromCart(
                      itemModel: controller.localCart[index].itemModel,
                    );
                  },
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.localCart[index].itemModel.name,
                        maxLines: 1,
                        style: MataajerTheme.mainTextStyle.copyWith(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        controller.localCart[index].itemModel.categoryUID,
                        maxLines: 1,
                        style: MataajerTheme.mainTextStyle.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w200,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'ر.س ${controller.localCart[index].totalAmount}',
                        maxLines: 1,
                        style: MataajerTheme.mainTextStyle.copyWith(
                          fontSize: 20,
                          color: MataajerTheme.mainColor,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          controller.increaseQuantity(index);
                        },
                        splashRadius: 15,
                        icon: const Icon(Icons.add),
                      ),
                      Container(
                        width: 30.w,
                        height: 30.h,
                        padding: EdgeInsets.only(top: 3.0.h),
                        decoration: BoxDecoration(
                          color: MataajerTheme.mainColor,
                          borderRadius: BorderRadius.circular(50.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12.withOpacity(0.02),
                              offset: const Offset(0, 0),
                              blurRadius: 5.r,
                              spreadRadius: 2.r,
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            controller.localCart[index].quantity.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.decreaseQuantity(index);
                        },
                        splashRadius: 15,
                        icon: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
