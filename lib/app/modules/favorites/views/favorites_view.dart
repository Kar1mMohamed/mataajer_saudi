import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/back_button.dart';
import 'package:mataajer_saudi/app/widgets/loading_image.dart';
import 'package:mataajer_saudi/app/widgets/preview_shop_dialog.dart';
import '../controllers/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'قائمة المتاجر',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: GetBuilder<FavoritesController>(builder: (_) {
                return GridView.builder(
                  itemCount: controller.favs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 1.0.sp,
                    mainAxisSpacing: 1.0.sp,
                  ),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) =>
                      _favoriteCard(controller.shops[index]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _favoriteCard(ShopModule shop) {
    bool isLoved = controller.favs.contains(shop);
    String categoryString = shop.categories.first.name;
    return InkWell(
      onTap: () => Get.dialog(PreviewShopDialog(shop: shop)),
      child: Container(
        padding: EdgeInsets.only(left: 5.0.sp, right: 5.0.sp),
        margin: EdgeInsets.only(left: 5.0.sp, right: 5.0.sp, bottom: 5.0.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          // border: Border.all(
          //   color: MataajerTheme.mainColor,
          //   width: 1,
          // ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 5,
              child: InkWell(
                onTap: () {
                  controller.updateLoveState(shop);
                },
                child: Icon(
                  Icons.favorite,
                  color: isLoved ? Colors.red : const Color(0xFFC6C6C6),
                  size: 15.sp,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage: NetworkImage(shop.image),
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            shop.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            categoryString,
                            style: TextStyle(
                              color: MataajerTheme.mainColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.info_outlined,
                        color: Colors.grey.shade400,
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

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      title: Text('المتاجر المفضلة',
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
}
