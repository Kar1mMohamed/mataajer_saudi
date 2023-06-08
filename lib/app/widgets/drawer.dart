import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer(
      {super.key, required this.ads, required this.isShop, this.isAdmin});

  final List<AdModule> ads;
  final bool isShop;
  final bool? isAdmin;

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
            if (isAdmin ?? false)
              _forAdmin()
            else if (isShop)
              _forShop()
            else
              _forGuest(),
          ],
        ),
      ),
    );
  }

  Widget _forShop() {
    return Column(
      children: [
        _drawerItem(Assets.plusIcon, 'اضف متجرك الالكتروني',
            route: Routes.HOME),
        _drawerItem(
          Assets.notificationVector,
          'اشعارات العملاء',
          route: Routes.SHOP_CUSTOMERS_NOTIFICATIONS,
        ),
        _drawerItem(
          Assets.addAdVector,
          'اضف اعلانك',
          route: Routes.ADD_AD,
        ),
        _drawerItem(
          Assets.personIcon,
          'حسابي',
          route: Routes.SHOP_ACCOUNT,
        ),
        _drawerItem(
          Assets.exitVector,
          'تسجيل خروج',
          onTap: () async {
            final currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null) {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed(Routes.SPLASH);
            }
          },
        ),
      ],
    );
  }

  Widget _forGuest() {
    return Column(
      children: [
        _drawerItem(Assets.plusIcon, 'اضف متجرك الالكتروني',
            route: Routes.SHOP_LOGIN_AND_REGISTER,
            arguments: {'isNavigateToRegister': true}),
        _drawerItem(Assets.addPackageIcon, 'عرض باقات الاشتراك',
            route: Routes.SHOP_LOGIN_AND_REGISTER,
            arguments: {'isNavigateToRegister': true}),
        _drawerItem(Assets.loveIcon, 'المتاجر المفضلة',
            route: Routes.FAVORITES, arguments: {'ads': ads}),
      ],
    );
  }

  Widget _forAdmin() {
    return Column(
      children: [
        // _drawerItem(Assets.plusIcon, 'اضف متجرك الالكتروني',
        //     route: Routes.HOME),
        // _drawerItem(Assets.addPackageIcon, 'عرض باقات الاشتراك',
        //     route: Routes.SPLASH),
        _drawerItem('', 'الاشعارات المستقبلة',
            route: Routes.ADMIN_NOTIFICATION,
            customIcon:
                Icon(Icons.notifications, color: MataajerTheme.mainColor)),
      ],
    );
  }

  Widget _drawerItem(String imageAsset, String text,
      {String? route,
      dynamic arguments,
      Color? assetColor,
      void Function()? onTap,
      Widget? customIcon}) {
    final bool isActive = route == Get.currentRoute;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? MataajerTheme.mainColorLighten : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: ListTile(
          title: Row(
            children: [
              if (customIcon != null)
                customIcon
              else
                Image.asset(
                  imageAsset,
                  width: 20.w,
                  height: 20.h,
                  color: isActive
                      ? Colors.white
                      : (assetColor ?? MataajerTheme.mainColor),
                ),
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
          onTap: () {
            if (route != null) {
              Get.back();
              if (Get.previousRoute == route) {
                Get.back();
                return;
              }
              Get.toNamed(route, arguments: arguments);
            } else {
              if (onTap != null) onTap();
            }
          },
        ),
      ),
    );
  }
}
