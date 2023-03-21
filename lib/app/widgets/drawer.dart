import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.shops, required this.isShop});

  final List<ShopModule> shops;
  final bool isShop;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          bottomLeft: Radius.circular(50),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 24.0.sp, right: 4.0.sp),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 70,
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Image.asset(Assets.logo),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    top: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isShop) _forShop() else _forUser(),
          ],
        ),
      ),
    );
  }

  Widget _forShop() {
    return Column(
      children: [
        _drawerItem(Assets.plusIcon, 'اضف متجرك الالكتروني', Routes.HOME,
            isActive: true),
        _drawerItem(Assets.addPackageIcon, 'عرض باقات الاشتراك', Routes.HOME),
        _drawerItem(Assets.loveIcon, 'المتاجر المفضلة', Routes.FAVORITES,
            arguments: {'shops': shops}),
      ],
    );
  }

  Widget _forUser() {
    return Column(
      children: [
        _drawerItem(Assets.plusIcon, 'اضف متجرك الالكتروني', Routes.HOME,
            isActive: true),
        _drawerItem(Assets.addPackageIcon, 'عرض باقات الاشتراك', Routes.HOME),
        _drawerItem(Assets.loveIcon, 'المتاجر المفضلة', Routes.FAVORITES,
            arguments: {'shops': shops}),
      ],
    );
  }

  Widget _drawerItem(String imageAsset, String text, String route,
      {bool? isActive = false, dynamic arguments}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isActive! ? MataajerTheme.mainColorLighten : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: ListTile(
          title: Row(
            children: [
              Image.asset(imageAsset, width: 20.w, height: 20.h),
              SizedBox(width: 5.w),
              Text(
                text,
                style: MataajerTheme.drawerTextStyle.copyWith(
                  color:
                      isActive ? Colors.white : MataajerTheme.mainColorLighten,
                ),
              ),
            ],
          ),
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => Get.toNamed(route, arguments: arguments),
        ),
      ),
    );
  }
}
