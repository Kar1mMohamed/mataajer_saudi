import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';

extension ForAdmin on Widget {
  Widget get forAdmin {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(
          body: Center(child: Text('ليس لديك صلاحية للوصول هنا')));
    }
    var admins = Get.find<MainSettingsController>().admins;
    if (admins.contains(currentUser.uid)) {
      return this;
    }

    return const Scaffold(
        body: Center(child: Text('ليس لديك صلاحية للوصول هنا')));
  }
}
