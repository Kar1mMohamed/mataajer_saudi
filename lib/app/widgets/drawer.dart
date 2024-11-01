import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';

import '../data/modules/shop_module.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key, required this.shops, this.isAdmin});

  final List<ShopModule> shops;
  final bool? isAdmin;

  bool get isShop => FirebaseAuth.instance.currentUser != null;

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
            _header(),
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

  Widget _header() {
    return SizedBox(
      height: 70,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Image.asset(Assets.logoVectorJPG),
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
    );
  }

  Widget _forShop() {
    return Column(
      children: [
        _drawerItem(
          Assets.notificationVector,
          'اشعارات العملاء',
          route: Routes.SHOP_CUSTOMERS_NOTIFICATIONS,
        ),
        _drawerItem(
          Assets.addAdVector,
          'الاعلانات المنبثقة',
          route: Routes.ADD_POPUP_AD,
        ),
        // _drawerItem(
        //   Assets.addAdVector,
        //   'اضف اعلانك',
        //   route: Routes.ADD_AD,
        // ),
        _drawerItem(
          Assets.addAdVector,
          'عروض المنتجات',
          route: Routes.ADD_OFFER,
        ),
        _drawerItem(
          Assets.personIcon,
          'حسابي',
          route: Routes.SHOP_ACCOUNT,
        ),
        _drawerItem(
          Assets.bigLoveIcon,
          'المتاجر المفضلة',
          route: Routes.FAVORITES,
          arguments: {'shops': shops},
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
        _drawerItem(Assets.bigLoveIcon, 'المتاجر المفضلة',
            route: Routes.FAVORITES, arguments: {'shops': shops}),
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
        _drawerItem(
          '',
          'الاشعارات المستقبلة',
          route: Routes.ADMIN_NOTIFICATION,
          customIcon:
              const Icon(Icons.notifications, color: MataajerTheme.mainColor),
        ),
        _drawerItem(
          '',
          'عروض المنتجات',
          route: Routes.ADMIN_OFFERS,
          customIcon: const Icon(Icons.local_offer_rounded,
              color: MataajerTheme.mainColor),
        ),
        _drawerItem(
          Assets.addAdVector,
          'الاعلانات المنبثقة',
          route: Routes.ADMIN_POPUPADS,
        ),
        _drawerItem(
          '',
          'المتاجر',
          route: Routes.ADMIN_USERS,
          customIcon: const Icon(Icons.account_box_rounded,
              color: MataajerTheme.mainColor),
        ),
        _drawerItem(
          '',
          'الفواتير',
          route: Routes.ADMIN_INVOICES,
          customIcon:
              const Icon(Icons.wallet_rounded, color: MataajerTheme.mainColor),
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
          leading: customIcon ??
              Image.asset(
                imageAsset,
                height: 20.h,
                color: isActive
                    ? Colors.white
                    : (assetColor ?? MataajerTheme.mainColor),
              ),
          title: Text(
            text,
            style: MataajerTheme.drawerTextStyle.copyWith(
              color: isActive ? Colors.white : MataajerTheme.mainColorLighten,
            ),
          ),
          // title: Row(
          //   children: [
          //     if (customIcon != null)
          //       customIcon
          //     else
          //       Image.asset(
          //         imageAsset,
          //         width: 20.w,
          //         height: 20.h,
          //         color: isActive
          //             ? Colors.white
          //             : (assetColor ?? MataajerTheme.mainColor),
          //       ),
          //     SizedBox(width: 5.w),
          //     Text(
          //       text,
          //       style: MataajerTheme.drawerTextStyle.copyWith(
          //         color:
          //             isActive ? Colors.white : MataajerTheme.mainColorLighten,
          //       ),
          //     ),
          //   ],
          // ),
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
