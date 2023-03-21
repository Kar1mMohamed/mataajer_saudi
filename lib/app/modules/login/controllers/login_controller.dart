import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/routes/app_pages.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class LoginController extends GetxController {
  final mainAccountController = Get.find<MainAccountController>();
  RxBool isShopOwner = false.obs;

  @override
  void onInit() {
    isShopOwner.listen((v) {
      mainAccountController.isShopOwner = v;
      log('isShopOwner: $v');
    });
    super.onInit();
  }
}
