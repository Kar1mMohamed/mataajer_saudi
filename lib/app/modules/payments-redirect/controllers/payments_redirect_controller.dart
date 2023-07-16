import 'package:get/get.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class PaymentsRedirectController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    log(Uri.base
        .toString()); // http://localhost:8082/game.html?id=15&randomNumber=3.14
    log(Uri.base.query); // id=15&randomNumber=3.14
    log(Uri.base.queryParameters['randomNumber'].toString()); // 3.14
  }
}
