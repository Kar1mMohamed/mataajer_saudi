import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';

class KSnackBar {
  KSnackBar._();
  static void success(String text, {BuildContext? context}) =>
      ScaffoldMessenger.of(context ?? Get.context!).showSnackBar(SnackBar(
          content: Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.green));

  static void error(String text, {BuildContext? context}) =>
      ScaffoldMessenger.of(context ?? Get.context!).showSnackBar(SnackBar(
          content: Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red));

  static void show(String text, {Color? color, BuildContext? context}) =>
      ScaffoldMessenger.of(context ?? Get.context!).showSnackBar(SnackBar(
          content: Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white)),
          backgroundColor: color ?? MataajerTheme.mainColor));
}
