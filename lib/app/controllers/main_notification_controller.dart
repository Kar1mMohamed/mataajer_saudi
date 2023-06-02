import 'package:get/get.dart';
import 'package:mataajer_saudi/database/notification.dart';

class MainNotificationController extends GetxController {
  RxInt get notificationCount => NotificationModule.notCount;
}
