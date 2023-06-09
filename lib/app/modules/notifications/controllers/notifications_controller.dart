import 'package:get/get.dart';
import 'package:mataajer_saudi/database/notification.dart';

class NotificationsController extends GetxController {
  bool get isThereNoNotifications => _notifications.isEmpty;
  List<NotificationModule> _notifications = [];

  bool loading = true;

  List<NotificationModule> get todayNotifications => _notifications
      .where(
        (element) =>
            element.date!.day == DateTime.now().day &&
            element.date!.month == DateTime.now().month &&
            element.date!.year == DateTime.now().year,
      )
      .toList();

  List<NotificationModule> get yesterdayNotifications => _notifications
      .where(
        (element) =>
            element.date!.day == DateTime.now().day - 1 &&
            element.date!.month == DateTime.now().month &&
            element.date!.year == DateTime.now().year,
      )
      .toList();

  List<NotificationModule> get otherNotifications => _notifications
      .where((element) =>
          !todayNotifications.contains(element) &&
          !yesterdayNotifications.contains(element))
      .toList();

  void getNotifications() async {
    try {
      _notifications = NotificationModule.notifications;
    } catch (e) {
      print(e);
    } finally {
      loading = false;
      update();
    }
  }

  @override
  void onInit() {
    getNotifications();
    super.onInit();
  }
}
