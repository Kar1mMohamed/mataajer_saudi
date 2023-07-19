import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/assets.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(Assets.logoVectorJPG),
        ),
      );
    });
  }
}
