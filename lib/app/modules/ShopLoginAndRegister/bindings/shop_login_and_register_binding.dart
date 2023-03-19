import 'package:get/get.dart';

import '../controllers/shop_login_and_register_controller.dart';

class ShopLoginAndRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopLoginAndRegisterController>(
      () => ShopLoginAndRegisterController(),
      fenix: true,
    );
  }
}
