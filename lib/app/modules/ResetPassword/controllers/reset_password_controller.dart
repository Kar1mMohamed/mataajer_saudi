import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';

import '../../../utils/log.dart';

class ResetPasswordController extends GetxController {
  final bool isEmailVerify = Get.arguments?['isEmailVerify'] ?? false;

  String get title =>
      isEmailVerify ? 'تأكيد البريد الالكتروني' : 'تغيير كلمة المرور';

  bool loading = false;

  // StreamSubscription<User?> get authStateChanges =>
  //     FirebaseAuth.instance.authStateChanges().listen(_listen);

  // void listenToAccountIfVerfiy() async {
  //   if (isEmailVerify) {
  //     authStateChanges;
  //   }
  // }

  // void _listen(User? user) async {
  //   log('user: $user');
  //   if (user != null && user.emailVerified) {
  //     KSnackBar.success('تم تأكيد البريد الالكتروني');
  //     await Future.delayed(const Duration(seconds: 1));
  //     Get.offAllNamed(Routes.HOME);
  //     authStateChanges.cancel();
  //   }
  // }

  Future<void> checkIFEmailVerified() async {
    loading = true;
    update();
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await currentUser.reload();
        await currentUser.reload();

        if (currentUser.emailVerified) {
          Get.offAllNamed(Routes.HOME);
        } else {
          KSnackBar.error('برجاء تأكيد البريد الالكتروني');
        }
      }
    } catch (e) {
      log(e);
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> resendEmailVerification() async {
    loading = true;
    update();

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.sendEmailVerification();
        KSnackBar.success('تم ارسال رسالة تأكيد البريد الالكتروني');
      }
    } catch (e) {
      log(e);
    } finally {
      loading = false;
      update();
    }
  }
}
