import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mataajer_saudi/app/controllers/app_life_cycle_controller.dart';
import 'package:mataajer_saudi/app/functions/url_launcher.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import '../data/app/life_cycle_enum.dart';

class MainNotificationController extends GetxController {
  RxInt notificationCount = 0.obs;
  String toRunLink = '';

  Future<void> getNotificationsCount() async {
    try {
      final deviceUUID = GetStorage().read<String>('deviceUUID');
      log('deviceUUID: $deviceUUID');
      if (deviceUUID == null) {
        throw 'deviceUUID is null';
      }
      final notificationCount = await FirebaseFirestore.instance
          .collection('fcm_tokens')
          .doc(deviceUUID)
          .collection('notifications')
          .where('isRead', isNotEqualTo: true)
          .get()
          .then((value) => value.docs.length);

      log('got notificationCount: $notificationCount');

      this.notificationCount.value = notificationCount;
    } catch (e) {
      log('getNotificationsCount: $e');
    } finally {
      update();
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> notificationSnapshot() {
    final deviceUUID = GetStorage().read<String>('deviceUUID');
    return FirebaseFirestore.instance
        .collection('fcm_tokens')
        .doc(deviceUUID!)
        .collection('notifications')
        .snapshots();
  }

  @override
  void onInit() {
    super.onInit();
    Get.find<AppLifeCylceController>().appLifeCyle.listen((value) {
      if (value == AppLifeCycleEnum.Resumed) {
        URLLauncherFuntions.launchURL(toRunLink);
      }
    });
  }
}
