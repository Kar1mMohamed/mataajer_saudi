import 'package:get/get.dart';

class PaymentsRedirectController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    print(Uri.base
        .toString()); // http://localhost:8082/game.html?id=15&randomNumber=3.14
    print(Uri.base.query); // id=15&randomNumber=3.14
    print(Uri.base.queryParameters['randomNumber']); // 3.14
  }
}
