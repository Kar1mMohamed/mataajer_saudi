import 'package:get/get.dart';

import '../controllers/shop_customers_notifications_controller.dart';

class ShopCustomersNotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShopCustomersNotificationsController>(
      () => ShopCustomersNotificationsController(),
    );
  }
}
