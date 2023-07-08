import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  bool get isCanBack => Get.previousRoute != '';
  @override
  Widget build(BuildContext context) {
    // if (!isCanBack) {
    //   return Container();
    // }
    return Container(
      height: 40,
      width: 60,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          color: const Color(0xFF626262),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
            log('back');
          },
        ),
      ),
    );
  }
}
