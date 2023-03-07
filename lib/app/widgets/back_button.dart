import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
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
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 234, 233, 233),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton(
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
