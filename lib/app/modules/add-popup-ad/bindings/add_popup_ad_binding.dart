import 'package:get/get.dart';

import '../controllers/add_popup_ad_controller.dart';

class AddPopupAdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddPopupAdController>(
      () => AddPopupAdController(),
      fenix: true,
    );
  }
}
