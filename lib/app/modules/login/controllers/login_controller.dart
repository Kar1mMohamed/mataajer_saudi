import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';

class LoginController extends GetxController {
  final mainAccountController = Get.find<MainAccountController>();
  RxBool isShopOwner = false.obs;

  @override
  void onInit() {
    isShopOwner.listen((v) {
      mainAccountController.isShopOwner = v;
    });
    super.onInit();
  }
}
