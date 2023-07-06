import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/drawer.dart';
import 'package:mataajer_saudi/app/widgets/preview_shop_dialog.dart';
import 'package:mataajer_saudi/database/notification.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: MyDrawer(shops: controller.shops, isShop: controller.isShop),
      body: SingleChildScrollView(
        child: GetBuilder<HomeController>(builder: (_) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _search(),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'تصنيفات المتاجر',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        Get.bottomSheet(_categoriesBottomSheet());
                      },
                      child: Text(
                        'عرض المزيد ',
                        style: TextStyle(
                          color: MataajerTheme.mainColorDarken,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                height: 40.h,
                child: GetBuilder<HomeController>(
                    id: 'categories',
                    builder: (_) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.categoriesList.length,
                        itemBuilder: (context, index) {
                          return _categoryCard(index);
                        },
                      );
                    }),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.all(8.0.sp),
                child: _homeBanner(context),
              ),
              SizedBox(height: 20.h),
              GetBuilder<HomeController>(
                  id: 'all-ads',
                  builder: (context) {
                    return _ads();
                  }),
            ],
          );
        }),
      ),
    );
  }

  Widget _homeBanner(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: context.isTablet ? context.height * 0.24 : 100.h,
          width: context.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0.r),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.homeBanner),
              filterQuality: FilterQuality.high,
            ),
          ),
          child: Container(
            width: context.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0.r),
              backgroundBlendMode: BlendMode.darken,
              gradient: LinearGradient(
                begin: FractionalOffset.topLeft,
                end: FractionalOffset.topRight,
                stops: [0.5, double.infinity],
                colors: [
                  MataajerTheme.mainColor.withOpacity(0.7),
                  Colors.white.withOpacity(0.1),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'عروض الجمعة الخضراء',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 1),
                          blurRadius: 1.r,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    """احصل على خصومات على منتجات
            مختارة تصل الى 60%""",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 1),
                          blurRadius: 1.r,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _ads() {
    List<ShopModule> staticAds = controller.shops
        .where((element) => element.isStaticAd ?? false)
        .toList();

    List<ShopModule> mostViewed = [];
    mostViewed.addAll(controller.shops);
    mostViewed.sort((a, b) => (b.hits ?? 0).compareTo(a.hits ?? 0));

    List<ShopModule> mostOffers =
        controller.shops.where((element) => element.isMostOffers).toList();

    List<ShopModule> others =
        controller.shops.where((element) => element.isOtherAd).toList();

    return Column(
      children: [
        _adItem('متاجر مثبتة', Icons.keyboard_arrow_up, staticAds, 1),
        _adItem('الاكثر زيارة', Icons.remove_red_eye_outlined, mostViewed, 2),
        _adItem('الاكثر عروضا', Icons.percent, mostOffers, 2),
        _adItem('متاجر اخرى', Icons.maps_home_work_outlined, others, 2),
      ],
    );
  }

  Widget _adItem(String text, IconData icon, List list, int crossCount) {
    double height = crossCount == 1 ? 170.h : (170.h * 2);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: MataajerTheme.mainColor,
                  borderRadius: BorderRadius.circular(20.0.r),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                text,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5.h),
        SizedBox(
          height: height,
          width: double.infinity,
          child: GetBuilder<HomeController>(
              id: 'ads',
              builder: (_) {
                return GridView.count(
                  crossAxisCount: crossCount,
                  childAspectRatio: 1.4,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                      list.length, (index) => _adCard(list[index])),
                );
              }),
        ),
      ],
    );
  }

  Widget _search() {
    return TextField(
      onChanged: controller.search,
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
          minWidth: 30.spMin,
          minHeight: 30.spMax,
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
          borderRadius: BorderRadius.circular(30.0.r),
        ),
      ),
    );
  }

  Widget _categoryCard(int index) {
    bool isActive = controller.categorySelectedIndex == index;
    return InkWell(
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        controller.updateCategorySelectedIndex(index);
        controller.changeAdsForCategory(controller.categoriesList[index]);
      },
      child: Container(
        margin: EdgeInsets.only(right: index != 0 ? 10.w : 0.00),
        padding: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: isActive ? MataajerTheme.mainColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: MataajerTheme.mainColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (index == 0)
              Image.asset(
                Assets.allIcon,
                height: 50.h,
                color: !isActive ? MataajerTheme.mainColor : null,
              ),
            Text(
              controller.categoriesList[index].name,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.black,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _adCard(ShopModule shop) {
    return GetBuilder<HomeController>(
        id: 'shopCard-${shop.uid}',
        builder: (_) {
          if (controller.adsLoading) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                image: const DecorationImage(
                  image: AssetImage(Assets.loadingGIF),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }
          bool isLoved = controller.favShops.contains(shop);
          String categoryString = shop.categories.first.name;
          return InkWell(
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => Get.dialog(PreviewShopDialog(shop: shop)),
            child: Container(
              padding: EdgeInsets.only(left: 5.0.sp, right: 5.0.sp),
              margin:
                  EdgeInsets.only(left: 5.0.sp, right: 5.0.sp, bottom: 10.0.sp),
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
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        controller.updateLoveState(shop);
                        print('loved ${shop.uid}');
                      },
                      child: Icon(
                        Icons.favorite,
                        color: isLoved
                            ? Colors.red.shade600
                            : const Color(0xFFC6C6C6),
                        size: 25.sp,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
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
                          children: [
                            Flexible(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    shop.name,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    categoryString,
                                    style: TextStyle(
                                      color: MataajerTheme.mainColor,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5.w),
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
        });
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      title: _appBarTitle(),
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
          },
        )
      ],
    );
  }

  Widget _appBarTitle() {
    return GetBuilder<HomeController>(
        id: '_appBarTitle',
        builder: (_) {
          if (controller.loading) {
            return const CircularProgressIndicator();
          }

          if (controller.isSignedIn) {
            if (controller.currentShop == null) {
              return _errorTitleAppBar;
            }
            if (controller.currentShop!.isSubscriptionExpired) {
              return _expiredTitleAppBar;
            } else {
              return _activeTitleAppBar;
            }
          } else {
            return _guestTitleAppBar;
          }
        });
  }

  BottomSheet _categoriesBottomSheet() {
    return BottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
      onClosing: () {},
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10.sp),
          child: GetBuilder<HomeController>(
              id: 'categories',
              builder: (_) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'تصنيفات المتاجر',
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(Icons.close))
                      ],
                    ),
                    SizedBox(height: 10.h),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.categoriesList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        // crossAxisSpacing: 10,
                        // mainAxisSpacing: 10,
                        childAspectRatio: 2,
                      ),
                      itemBuilder: (context, index) {
                        bool isActive =
                            controller.categorySelectedIndex == index;
                        return InkWell(
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            controller.updateCategorySelectedIndex(index);
                            controller.changeAdsForCategory(
                                controller.categoriesList[index]);
                          },
                          child: Container(
                            margin: EdgeInsets.all(5.0.sp),
                            // padding: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? MataajerTheme.mainColor
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(25.r),
                              border: Border.all(
                                color: MataajerTheme.mainColor,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                controller.categoriesList[index].name,
                                style: TextStyle(
                                  color: isActive ? Colors.white : Colors.black,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget get _errorTitleAppBar {
    return InkWell(
      onTap: () {
        KSnackBar.error('برجاء اعادة فتح التطبيق مره اخرى');
      },
      child: Container(
        height: 40.h,
        padding: EdgeInsets.all(10.sp),
        margin: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6145),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'حدث خطأ ما',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _expiredTitleAppBar {
    return InkWell(
      onTap: () async {
        final res = await controller.currentShop?.renewSubscription();
        if (res == null) {
          KSnackBar.error('عفوا لم يتم تجديد الاشتراك');
          return;
        }

        KSnackBar.success('تم تجديد الاشتراك بنجاح برجاء الدخول مره اخرى');
        await Future.delayed(const Duration(seconds: 2));

        Get.offAndToNamed(Routes.ON_BARDING);
      },
      child: Container(
        height: 40.h,
        padding: EdgeInsets.all(10.sp),
        margin: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6145),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.renewVectorPNG,
              filterQuality: FilterQuality.high,
            ),
            SizedBox(width: 5.w),
            Text(
              'تجديد الاشتراك',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _activeTitleAppBar {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        KSnackBar.success(
            'يبدو ان الاشتراك مفعل بالفعل، نحن سعداء باشتراكك معنا');
      },
      child: Container(
        height: 40.h,
        padding: EdgeInsets.all(10.sp),
        margin: EdgeInsets.all(10.sp),
        decoration: BoxDecoration(
          color: const Color(0xFF4CCA5A),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.renewVectorPNG,
              filterQuality: FilterQuality.high,
            ),
            SizedBox(width: 5.w),
            Text(
              'مفعل',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _guestTitleAppBar {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'متاجر',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
        ).marginAll(4.sp),
        Text(
          'سعودي',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: MataajerTheme.mainColor,
          ),
        ),
      ],
    );
  }
}
