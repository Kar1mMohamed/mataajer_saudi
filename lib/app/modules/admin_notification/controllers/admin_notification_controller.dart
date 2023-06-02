import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';

import '../../../../database/notification.dart';

class AdminNotificationController extends GetxController {
  bool loadng = false;

  bool get isThereNoNotifications => notifications.isEmpty;
  List<NotificationModule> notifications = [];

  List<ShopModule> shops = [];

  Future<void> getNotifications() async {
    try {
      final notifications = await FirebaseFirestoreHelper.instance
          .getAllNotifications(statusNotActive: true);

      this.notifications = notifications;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllShops() async {
    try {
      final shops = await FirebaseFirestoreHelper.instance.getShops();
      this.shops = shops;
    } catch (e) {
      print(e);
    }
  }

  String? getSenderUserImage(NotificationModule module) {
    final shop = shops
        .firstWhereOrNull((element) => element.uid == module.senderUserUID);
    return shop?.image;
  }

  @override
  void onInit() async {
    loadng = true;
    update();
    await getAllShops();
    await getNotifications();
    loadng = false;
    update();
    super.onInit();
  }
}
