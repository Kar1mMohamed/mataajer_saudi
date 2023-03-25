import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/assets.dart';
import 'package:mataajer_saudi/app/widgets/back_button.dart';
import 'package:mataajer_saudi/app/widgets/drawer.dart';

import '../controllers/add_ad_controller.dart';

class AddAdView extends GetView<AddAdController> {
  const AddAdView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: MyDrawer(shops: const [], isShop: true),
      body: GetBuilder<AddAdController>(builder: (_) {
        if (controller.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Center(
          child: Text(
            'AddAdView is working',
            style: TextStyle(fontSize: 20),
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
      title: Text('اضافة اعلان',
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
        // THIS TO ROTATE THE BACK BUTTON
        RotatedBox(
          quarterTurns: 2,
          child: Transform.translate(
            offset: const Offset(-10, 0),
            child: const CustomBackButton(),
          ),
        ),
      ],
      leadingWidth: 50.w,
    );
  }
}
