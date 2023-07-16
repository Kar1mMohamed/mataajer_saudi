import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mataajer_saudi/app/controllers/main_notification_controller.dart';
import 'package:mataajer_saudi/database/notification.dart';

import '../../../utils/log.dart';

class NotificationsController extends GetxController {
  bool loading = true;

  Stream<QuerySnapshot<Map<String, dynamic>>> get notificationsSnapshots =>
      Get.find<MainNotificationController>().notificationSnapshot();

  List<NotificationModule> _notifications = [];

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

  Future<void> getNotifications() async {
    loading = true;
    update();
    try {
      final deviceUUID = GetStorage().read<String>('deviceUUID');
      final notificationsDocs = await FirebaseFirestore.instance
          .collection('fcm_tokens')
          .doc(deviceUUID)
          .collection('notifications')
          .get()
          .then((response) => response.docs);

      for (var doc in notificationsDocs) {
        doc.reference.update({'isRead': true});
      }

      _notifications = notificationsDocs
          .map((e) => NotificationModule.fromMap(e.data()))
          .toList();
    } catch (e) {
      log(e);
    } finally {
      loading = false;
      update();
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await getNotifications();
    Get.find<MainNotificationController>().notificationCount.value = 0;
    Get.find<MainNotificationController>().update();
  }
}
