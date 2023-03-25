import 'package:get/get.dart';

import '../controllers/add_ad_controller.dart';

class AddAdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddAdController>(
      () => AddAdController(),
    );
  }
}
