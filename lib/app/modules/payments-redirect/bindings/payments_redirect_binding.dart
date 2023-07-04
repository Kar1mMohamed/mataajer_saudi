import 'package:get/get.dart';

import '../controllers/payments_redirect_controller.dart';

class PaymentsRedirectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentsRedirectController>(
      () => PaymentsRedirectController(),
      fenix: true,
    );
  }
}
