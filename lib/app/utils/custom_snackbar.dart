import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  CustomSnackBar._();
  static void error(String message) {
    Get.snackbar(
      'Error'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  static void success(String message) {
    Get.snackbar(
      'Success'.tr,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  static void floatingSnackBar(String message, Color color) {
    final context = Get.context!;
    const gradient = LinearGradient(
      colors: [
        Colors.green,
        Color(0xFFE0E0E0),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => gradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 2),
        margin: EdgeInsets.only(bottom: context.height * 0.1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
