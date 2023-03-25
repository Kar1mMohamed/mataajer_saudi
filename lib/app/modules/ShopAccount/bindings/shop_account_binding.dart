import 'package:get/get.dart';

import '../controllers/shop_account_controller.dart';

class ShopAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopAccountController>(
      () => ShopAccountController(),
    );
  }
}
