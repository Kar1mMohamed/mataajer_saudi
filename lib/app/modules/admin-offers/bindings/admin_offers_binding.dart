import 'package:get/get.dart';

import '../controllers/admin_offers_controller.dart';

class AdminOffersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminOffersController>(
      () => AdminOffersController(),
      fenix: true,
    );
  }
}
