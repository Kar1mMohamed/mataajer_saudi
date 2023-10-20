import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/extensions/for_admin.dart';
import 'package:mataajer_saudi/app/functions/url_launcher.dart';

import '../../../functions/firebase_firestore.dart';
import '../../../theme/theme.dart';
import '../../../widgets/back_button.dart';
import '../../../widgets/drawer.dart';
import '../../../widgets/loading_image.dart';
import '../../../widgets/rounded_button.dart';
import '../../../widgets/textfield.dart';
import '../controllers/admin_popupads_controller.dart';

class AdminPopupadsView extends GetView<AdminPopupadsController> {
  const AdminPopupadsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: const MyDrawer(shops: [], isAdmin: true),
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: GetBuilder<AdminPopupadsController>(builder: (context) {
          if (controller.loading) {
            return MataajerTheme.loadingWidget;
          }
          if (controller.popUpAds.isEmpty) {
            return const Center(child: Text('لا يوجد اعلانات'));
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: RoundedButton(
                        text: 'الجديدة',
                        press: () {
                          controller.showIsNotActive = true;
                          controller.update();
                        },
                        color: controller.showIsNotActive
                            ? MataajerTheme.mainColor
                            : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: RoundedButton(
                        text: 'جميع الاعلانات',
                        press: () {
                          controller.showIsNotActive = false;
                          controller.update();
                        },
                        color: controller.showIsNotActive
                            ? Colors.grey
                            : MataajerTheme.mainColor,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Builder(builder: (context) {
                    if (controller.popUpAds.isEmpty) {
                      return const Center(child: Text('لا يوجد اشعارات'));
                    }

                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.popUpAds.length,
                      itemBuilder: (context, index) => _adCard(index),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10.h),
                    );
                  }),
                ),
              ],
            ),
          );
        }).forAdmin,
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      elevation: 0,
      title: Text('الاعلانات المنبثقة',
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

  Widget _adCard(int index) {
    final ad = controller.popUpAds[index];
    if (controller.showIsNotActive && !ad.isCanAcceptOrCancel) {
      return Container();
    }
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Get.dialog(
                Dialog(
                  child: SizedBox(
                    width: 300.w,
                    height: 300.h,
                    child: LoadingImage(
                      src: ad.image,
                    ),
                  ),
                ),
              );
            },
            child: CircleAvatar(
              radius: 25.r,
              backgroundImage: NetworkImage(
                ad.image,
                // fit: BoxFit.cover,
                // height: 150,
                // width: 150,
              ),
            ),
          ),
          SizedBox(width: 5.w),
          Flexible(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    if (ad.url != null) {
                      URLLauncherFuntions.launchURL(ad.url!);
                    }
                  },
                  child: Text(
                    ad.url ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.blue, overflow: TextOverflow.ellipsis),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (ad.cancelReason != null)
                  Text(
                    'سبب الرفض: ${ad.cancelReason}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  final cancelReasonController = TextEditingController();
                  Get.dialog(
                    Dialog(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0.sp, vertical: 10.0.sp),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            textField(
                              hint: 'سبب الرفض',
                              controller: cancelReasonController,
                            ),
                            RoundedButton(
                              text: 'رفض',
                              press: () async {
                                await controller.cancelFunction(ad
                                  ..cancelReason = cancelReasonController.text);
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
              ),
              if (!(ad.isVisible ?? false) && ad.isCanAcceptOrCancel)
                IconButton(
                  onPressed: () async {
                    await FirebaseFirestoreHelper.instance
                        .updatePopUpAdVisibility(ad..isVisible = true);

                    ad.isVisible = true;

                    controller.update();
                  },
                  icon: const Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
