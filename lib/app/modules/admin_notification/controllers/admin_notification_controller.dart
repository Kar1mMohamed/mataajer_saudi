import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../../database/notification.dart';
import '../../../../utils/ksnackbar.dart';
import '../../../data/modules/send_notification_module.dart';
import '../../../functions/cloud_messaging.dart';
import '../../../utils/log.dart';

class AdminNotificationController extends GetxController {
  bool loading = false;

  bool get isThereNoNotifications => notifications.isEmpty;
  List<NotificationModule> notifications = [];

  List<ShopModule> shops = [];

  bool showIsNotActive = false;

  void updateNotificationCard(int index) {
    update(['$index']);
  }

  Future<void> getNotifications() async {
    try {
      final notifications = await FirebaseFirestoreHelper.instance
          .getAllNotifications(forAdmin: true);

      notifications.sort((a, b) => b.date!.compareTo(a.date!));

      this.notifications = notifications;
    } catch (e) {
      log(e);
    }
  }

  Future<void> getAllShops() async {
    try {
      final shops = await FirebaseFirestoreHelper.instance.getShops();
      this.shops = shops;
    } catch (e) {
      log(e);
    }
  }

  String? getSenderUserImage(NotificationModule module) {
    final shop = shops
        .firstWhereOrNull((element) => element.uid == module.senderUserUID);
    return shop?.image;
  }

  Future<void> _sendNotificationAdmin(
      NotificationModule module, int index) async {
    if (module.senderUserUID == null) {
      KSnackBar.error('عنوان UID المستخدم غير موجود');
      return;
    }

    module.isActive = true;
    updateNotificationCard(index);
    try {
      final shopModule = shops
          .firstWhereOrNull((element) => element.uid == module.senderUserUID);

      // if you want to limit the number of notifications sent on the system
      bool isHasLimit = await CloudMessaging.checkIfUserHasLimit(shopModule!);

      if (!isHasLimit) {
        KSnackBar.error('لقد تجاوز المتجر الحد الاقصى للارسال');
        return;
      }

      List<String> allFCMTokens =
          await FirebaseFirestoreHelper.instance.getAllFCMTokens();
      log('allFCMTokens: $allFCMTokens');

      if (allFCMTokens.isEmpty) {
        log('allFCMTokens is empty');
      }

      List<SendNotifictaionModule> sendModules = allFCMTokens.map((e) {
        return SendNotifictaionModule(
          title: module.title!,
          body: module.body!,
          token: e,
          data: module.data,
        );
      }).toList();

      for (var i = 0; i < sendModules.length; i++) {
        module.sendingText =
            'جاري ارسال الاشعارات ${i + 1} من ${sendModules.length}';
        updateNotificationCard(index);
        await CloudMessaging.sendNotification(sendModules[i]);
      }

      final allFCMTokenDocs = await FirebaseFirestore.instance
          .collection('fcm_tokens')
          .get()
          .then((value) => value.docs);

      final batch = FirebaseFirestore.instance.batch();

      for (var doc in allFCMTokenDocs) {
        final docUID = const Uuid().v5(Uuid.NAMESPACE_X500,
            '${doc.id}-${DateTime.now().millisecondsSinceEpoch}');
        final newDoc = doc.reference.collection('notifications').doc(docUID);
        batch.set(newDoc, module.toMap());
        log('writing notification to: ${newDoc.id}');
      }

      await batch.commit();

      final dateUID = '${DateTime.now().year}-${DateTime.now().month}';

      await CloudMessaging.increaseSentNumber(module.senderUserUID!, dateUID);

      await getNotifications();

      KSnackBar.success('تم ارسال الاشعارات بنجاح');
    } catch (e) {
      log(e);
    } finally {
      module.sendingText = '';
      await onRefresh();
      updateNotificationCard(index);
    }
  }

  Future<void> accept(NotificationModule module, int index) async {
    loading = true;
    updateNotificationCard(index);

    try {
      await _sendNotificationAdmin(module, index);
      await FirebaseFirestoreHelper.instance.acceptNotification(module);
      notifications.remove(module);
      update();
      KSnackBar.success('تم قبول الاشعار بنجاح');
    } catch (e) {
      log(e);
      KSnackBar.error('حدث خطأ اثناء قبول الاشعار - $e');
    } finally {
      loading = false;
      updateNotificationCard(index);
    }
  }

  Future<void> cancelFunction(NotificationModule module, int index) async {
    loading = true;
    updateNotificationCard(index);
    try {
      await FirebaseFirestoreHelper.instance.updateNotification(module);

      KSnackBar.success('تم الغاء الاشعار بنجاح');
    } catch (e) {
      log(e);
      KSnackBar.error('حدث خطأ اثناء الغاء الاشعار - $e');
    } finally {
      onRefresh();
    }
  }

  Future<void> deleteExpiredTokens() async {
    try {
      final allToknes = await FirebaseFirestore.instance
          .collection('fcm_tokens')
          .get()
          .then((value) => value.docs);

      final batch = FirebaseFirestore.instance.batch();

      for (var token in allToknes) {
        var createdAt = DateTime.parse(token.data()['createdAt']);
        var now = DateTime.now();
        var difference = now.difference(createdAt).inDays;

        if (difference > 14) {
          log('deleteExpiredTokens: ${token.data()}');
          batch.delete(token.reference);
        }
      }

      await batch.commit();
    } catch (e) {
      log('deleteExpiredTokens: $e');
    }
  }

  Future<void> onRefresh() async {
    loading = true;
    update();
    try {
      await deleteExpiredTokens();
      await getAllShops();
      await getNotifications();
    } catch (e) {
      log('onRefresh: $e');
    } finally {
      loading = false;
      update();
    }
  }

  @override
  void onInit() async {
    loading = true;
    update();
    await deleteExpiredTokens();
    await getAllShops();
    await getNotifications();
    loading = false;
    update();
    super.onInit();
  }
}
