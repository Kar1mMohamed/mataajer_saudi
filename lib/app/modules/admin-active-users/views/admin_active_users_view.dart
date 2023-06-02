import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/custom_switch.dart';
import 'package:mataajer_saudi/app/widgets/drawer.dart';
import 'package:mataajer_saudi/database/notification.dart';
import '../controllers/admin_active_users_controller.dart';

class AdminActiveUsersView extends GetView<AdminActiveUsersController> {
  const AdminActiveUsersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: const MyDrawer(ads: [], isShop: false, isAdmin: true),
      body: GetBuilder<AdminActiveUsersController>(builder: (_) {
        return Column(
          children: [
            SizedBox(height: 20.h),
            _switchButtons(),
            SizedBox(height: 20.h),
            _search(),
            SizedBox(height: 5.h),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: PageView(
                  physics: const BouncingScrollPhysics(),
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  children: [
                    GetBuilder<AdminActiveUsersController>(
                      id: 'allShops',
                      builder: (context) {
                        return allShops();
                      },
                    ),
                    GetBuilder<AdminActiveUsersController>(
                      id: 'activeShops',
                      builder: (context) {
                        return activeShops();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget allShops() {
    if (controller.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: controller.allShops.length,
      itemBuilder: (context, index) => GetBuilder<AdminActiveUsersController>(
          id: 'allShopsCard-$index',
          builder: (_) {
            if (controller.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return _shopCard(controller.allShops[index], index);
          }),
      separatorBuilder: (context, index) => SizedBox(height: 10.h),
    );
  }

  Widget activeShops() {
    if (controller.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: controller.activeShops.length,
      itemBuilder: (context, index) => GetBuilder<AdminActiveUsersController>(
          id: 'activeShopsCard-$index',
          builder: (_) {
            if (controller.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return _shopCard(controller.activeShops[index], index);
          }),
      separatorBuilder: (context, index) => SizedBox(height: 10.h),
    );
  }

  Widget _shopCard(ShopModule shop, int indedx) {
    return InkWell(
      onTap: () async {
        await Get.toNamed(Routes.SHOP_ACCOUNT, arguments: shop);
        controller.getAllShops();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 35.r,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(shop.image),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    children: [
                      Text(
                        shop.name,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        shop.categories.first.name,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: MataajerTheme.mainColor),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  CustomSwitch(
                    value: shop.isVisible!,
                    onChanged: (v) {
                      shop.isVisible = v;
                      controller.updateShopVisibility(shop, indedx);
                    },
                  ),
                  SizedBox(width: 10.w),
                  IconButton(
                    onPressed: () => controller.deleteShop(shop),
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      leadingWidth: 50.w,
      elevation: 0,
      title: Text('لوحة الأدمن',
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
        ValueListenableBuilder<Box<NotificationModule>>(
            valueListenable: NotificationModule.hiveBox.listenable(),
            builder: (context, box, widget) {
              var length = 0;
              if (box.isNotEmpty) {
                length = box.values
                    .where((element) =>
                        element.isRead == null || element.isRead == false)
                    .length;
              }
              return IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
                icon: Stack(
                  children: [
                    Icon(
                      Icons.notifications,
                      size: 30.h,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        margin: EdgeInsets.only(left: 10.w),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.fromBorderSide(
                            BorderSide(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Text(
                          '$length',
                          style: TextStyle(
                            fontSize: 8.5.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
      ],
    );
  }

  Widget _switchButtons() {
    return GetBuilder<AdminActiveUsersController>(builder: (_) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              controller.pageController.animateToPage(0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
              controller.onPageChanged(0);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: controller.pageIndex == 0
                    ? MataajerTheme.mainColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: controller.pageIndex == 0
                    ? null
                    : Border.all(color: MataajerTheme.mainColor),
              ),
              child: Text(
                'الحسابات المسجلة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: controller.pageIndex == 0
                      ? Colors.white
                      : MataajerTheme.mainColor,
                ),
              ),
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () {
              controller.pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
              controller.onPageChanged(1);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: controller.pageIndex == 1
                    ? MataajerTheme.mainColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: controller.pageIndex == 1
                    ? null
                    : Border.all(color: MataajerTheme.mainColor),
              ),
              child: Text(
                'الحسابات المفعلة',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: controller.pageIndex == 1
                      ? Colors.white
                      : MataajerTheme.mainColor,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _search() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller.searchTextController,
        onChanged: (v) {
          controller.search(v);
        },
        style: TextStyle(
          fontSize: 13.sp,
          color: const Color.fromARGB(255, 119, 119, 119),
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(right: 10.0.sp, bottom: 40.0.sp),
          prefixIcon: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Image.asset(Assets.searchIcon),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 30.w,
            minHeight: 30.h,
          ),
          fillColor: Colors.grey[200],
          hintText: '  ابحث عن المتاجر',
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: const Color.fromARGB(255, 119, 119, 119),
            fontWeight: FontWeight.w500,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 219, 219, 219), width: 1.0),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
