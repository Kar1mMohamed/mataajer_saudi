import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';

class ResetPasswordController extends GetxController {
  final bool isEmailVerify = Get.arguments?['isEmailVerify'] ?? false;

  String get title =>
      isEmailVerify ? 'تأكيد البريد الالكتروني' : 'تغيير كلمة المرور';

  bool loading = false;

  Future<void> checkIFEmailVerified() async {
    loading = true;
    update();
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await currentUser.reload();
        if (currentUser.emailVerified) {
          Get.offAllNamed(Routes.HOME);
        }
      }
    } catch (e) {
      print(e);
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
      print(e);
    } finally {
      loading = false;
      update();
    }
  }

  @override
  void onInit() {
    if (isEmailVerify) {
      checkIFEmailVerified();
    }
    super.onInit();
  }
}
