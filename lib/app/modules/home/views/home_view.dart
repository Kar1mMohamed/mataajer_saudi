import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/widgets/drawer.dart';
import 'package:mataajer_saudi/app/widgets/preview_shop_dialog.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: MyDrawer(ads: controller.ads, isShop: controller.isShop),
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
                padding: const EdgeInsets.all(8.0),
                child: _homeBanner(context),
              ),
              SizedBox(height: 20.h),
              GetBuilder<HomeController>(
                  id: 'ads',
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
          height: 100.0.h,
          width: context.width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0.r),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Assets.homeBanner),
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
                colors: [
                  MataajerTheme.mainColor.withOpacity(0.7),
                  Colors.white.withOpacity(0.1),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 150.0.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'عروض الجمعة الخضراء',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    """احصل على خصومات على منتجات
مختارة تصل الى 60%""",
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
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
    return Column(
      children: [
        _adItem('متاجر مثبتة', Icons.keyboard_arrow_up, controller.ads, 1),
        _adItem(
            'الاكثر زيارة', Icons.remove_red_eye_outlined, controller.ads, 2),
        _adItem('الاكثر عروضا', Icons.percent, controller.ads, 2),
        _adItem('متاجر اخرى', Icons.maps_home_work_outlined, controller.ads, 2),
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
              id: 'shops',
              builder: (_) {
                // return GridView.builder(
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 1, childAspectRatio: 1.5),
                //   scrollDirection: Axis.horizontal,
                //   itemCount: controller.categoriesList.length,
                //   shrinkWrap: true,
                //   itemBuilder: (context, index) {
                //     return _adCard(index);
                //   },
                // );
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

  Widget _adCard(AdModule ad) {
    return GetBuilder<HomeController>(
        id: 'shopCard-${ad.uid}',
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
          bool isLoved = controller.favAds.contains(ad);
          String categoryString = ad.categories.first.name;
          return InkWell(
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => Get.dialog(PreviewShopDialog(ad: ad)),
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
                        controller.updateLoveState(ad);
                        print('loved');
                      },
                      child: Icon(
                        Icons.favorite,
                        color: isLoved ? Colors.red : const Color(0xFFC6C6C6),
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
                          backgroundImage: NetworkImage(ad.imageURL),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ad.name,
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
      // title: Text(
      //   'الرئيسية',
      //   style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w500),
      // ),
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
        IconButton(
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
                    '2',
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
              return Container(
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
              );
            }
            if (controller.currentShop!.isSubscriptionExpired) {
              return Container(
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
                    Image.asset(Assets.renewVectorPNG),
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
              );
            } else {
              return Container(
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
                    Image.asset(Assets.renewVectorPNG),
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
              );
            }
          } else {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'متاجر',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 5.w),
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

  // Dialog _shopPreviewDialog() {
  //   return Dialog(
  //     insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 35.h),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
  //     child: Container(
  //       height: double.infinity,
  //       width: double.infinity,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(50.r),
  //       ),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           children: [
  //             Container(
  //               height: 90.h,
  //               width: double.infinity,
  //               decoration:
  //                   const BoxDecoration(color: MataajerTheme.mainColorLighten),
  //               child: Padding(
  //                 padding: const EdgeInsets.all(8.0),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
  //                   children: [
  //                     Container(
  //                       height: 75,
  //                       width: 75,
  //                       padding: const EdgeInsets.all(4),
  //                       decoration: const BoxDecoration(
  //                         color: Colors.white,
  //                         shape: BoxShape.circle,
  //                       ),
  //                       child: ClipOval(
  //                         child: SizedBox.fromSize(
  //                           size: const Size.fromRadius(48),
  //                           child: Image.network(
  //                             'https://mir-s3-cdn-cf.behance.net/projects/404/1cb86469753415.Y3JvcCwxMTUwLDg5OSwxMzc1LDY0Mw.jpg',
  //                             fit: BoxFit.cover,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Text(
  //                           'متجر نون',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 15.sp,
  //                             fontWeight: FontWeight.w400,
  //                           ),
  //                         ),
  //                         Text(
  //                           'تسوق منتجات',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 13.sp,
  //                             fontWeight: FontWeight.w400,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     Container(
  //                       decoration: BoxDecoration(
  //                         color: Colors.white.withOpacity(0.4),
  //                         borderRadius: BorderRadius.circular(50.r),
  //                       ),
  //                       child: Padding(
  //                         padding: EdgeInsets.all(8.0.sp),
  //                         child: Text(
  //                           'عدد الزيارات  ${Random().nextInt(100) + 1547}',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 13.sp,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: 10.0.h),
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'وصف المتجر',
  //                     style: TextStyle(
  //                       fontSize: 15.sp,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   SizedBox(height: 5.0.h),
  //                   Text(
  //                     """نون منصة التسوق الإلكتروني الرائدة في الشرق الأوسط. تسوق منتجاتك المفضلة من أزياء وإلكترونيات ومنتجات المنزل والجمال ومنتجات الأطفال أونلاين في السعودية.""",
  //                     style: TextStyle(
  //                       color: Colors.black.withOpacity(0.7),
  //                       fontSize: 15.sp,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(height: 20.h),
  //             Padding(
  //               padding: const EdgeInsets.all(12.0),
  //               child: Row(
  //                 children: [
  //                   Column(
  //                     children: [
  //                       Text(
  //                         'متوسط سعر \n الشحن',
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             fontSize: 12.0.sp, fontWeight: FontWeight.w500),
  //                       ),
  //                       Container(
  //                         padding: const EdgeInsets.all(25.0),
  //                         decoration: const BoxDecoration(
  //                           color: MataajerTheme.mainColor,
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: Column(
  //                           children: [
  //                             Text(
  //                               '25',
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 16.sp,
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             ),
  //                             Text(
  //                               'ريال',
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 15.sp,
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   SizedBox(width: 40.w),
  //                   Column(
  //                     children: [
  //                       Text(
  //                         'متوسط مدة \n الشحن',
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                             fontSize: 12.0.sp, fontWeight: FontWeight.w500),
  //                       ),
  //                       Container(
  //                         padding: const EdgeInsets.all(25.0),
  //                         decoration: const BoxDecoration(
  //                           color: MataajerTheme.mainColor,
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: Column(
  //                           children: [
  //                             Text(
  //                               '2-5',
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 16.sp,
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             ),
  //                             Text(
  //                               'ايام',
  //                               style: TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 15.sp,
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(height: 20.h),
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Row(
  //                 children: [
  //                   Container(
  //                     height: 35.h,
  //                     width: Get.context!.width * 0.3,
  //                     decoration: const BoxDecoration(
  //                       color: MataajerTheme.mainColorLighten,
  //                     ),
  //                     child: Center(
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Text(
  //                           'نسخ الكود',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 12.sp,
  //                             fontWeight: FontWeight.w700,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Container(
  //                     height: 35.h,
  //                     width: Get.context!.width * 0.5,
  //                     decoration: BoxDecoration(
  //                       color: Colors.grey.shade300,
  //                     ),
  //                     child: Center(
  //                       child: Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: Text(
  //                           'خصم 20% على جميع المنتجات',
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                             fontSize: 12.sp,
  //                             fontWeight: FontWeight.w500,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(height: 20.h),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 22.0),
  //               child: Align(
  //                 alignment: Alignment.centerRight,
  //                 child: Text(
  //                   'متاجر مشابهة',
  //                   style:
  //                       TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: 10.h),
  //             Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: SizedBox(
  //                 height: 100.h,
  //                 child: ListView.separated(
  //                   scrollDirection: Axis.horizontal,
  //                   itemBuilder: (context, index) => Column(
  //                     children: [
  //                       ClipRRect(
  //                         borderRadius: BorderRadius.circular(50.r),
  //                         child: Image.network(
  //                           'https://firebasestorage.googleapis.com/v0/b/mataajer-saudi.appspot.com/o/%D8%A7%D9%84%D9%88%D8%A7%D8%AF%D9%8A.jpg?alt=media&token=29 af9bc2-953f-48e5-a5ce-65a0ceeacdda',
  //                           height: 75.h,
  //                         ),
  //                       ),
  //                       SizedBox(height: 10.h),
  //                       const Text('متجر مشابه'),
  //                     ],
  //                   ),
  //                   separatorBuilder: (context, index) => SizedBox(width: 20.w),
  //                   itemCount: 5,
  //                   shrinkWrap: true,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
