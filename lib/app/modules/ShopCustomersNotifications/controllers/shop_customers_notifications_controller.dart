import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/cloud_messaging.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/database/notification.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';
import '../../../utils/log.dart';

class ShopCustomersNotificationsController extends GetxController {
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  final mainAccountController = Get.find<MainAccountController>();

  ShopModule? currentShop;

  bool get isShop => mainAccountController.isShopOwner;

  bool loading = true;

  final notTitleController = TextEditingController();
  final notLinkController = TextEditingController();

  List<NotificationModule> notifications = [];

  int? noOfMonthlyCandSend;

  void initNoOfMonthlySend() async {
    try {
      bool isCanSendTowNotification =
          currentShop!.isCanSendTwoNotification ?? false;
      bool isCanSendFourNotification =
          currentShop!.isCanSendFourNotification ?? false;

      if (isCanSendTowNotification && !isCanSendFourNotification) {
        noOfMonthlyCandSend = 2;
      } else if (isCanSendTowNotification && isCanSendFourNotification) {
        noOfMonthlyCandSend = 2 + 4;
      } else {
        noOfMonthlyCandSend = 0;
      }
    } catch (e) {
      log(e);
    }
  }

  Future<void> getNotifications() async {
    loading = true;
    update();

    try {
      notifications = await FirebaseFirestoreHelper.instance
          .getShopNotifications(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      log('getNotifications: $e');
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> deleteNotification(NotificationModule notification) async {
    try {
      await FirebaseFirestoreHelper.instance.deleteNotification(notification);
      // final dateUID = '${notification.date!.year}-${notification.date!.month}';
      // await CloudMessaging.decreaseSentNumber(
      //     FirebaseAuth.instance.currentUser!.uid, dateUID);

      notifications.remove(notification);
    } catch (e) {
      log('deleteNotification: $e');
    } finally {
      update();
    }
  }

  Future<void> sendNotification() async {
    if (notTitleController.text.isEmpty) {
      KSnackBar.error('من فضلك ادخل نص الاشعار');
      return;
    }

    if (currentShop == null || !currentShop!.canSendNotification) {
      KSnackBar.error('لا يمكنك ارسال الاشعارات');
      return;
    }

    loading = true;
    update();
    try {
      // if you want to limit the number of notifications sent on the system
      bool isHasLimit = await CloudMessaging.checkIfUserHasLimit(currentShop!);

      if (!isHasLimit) {
        KSnackBar.error('لقد تجاوزت الحد الاقصى للارسال');
        return;
      }

      final notificationModule = NotificationModule(
        title: 'اشعار من ${currentShop!.name}',
        body: notTitleController.text,
        data: {
          'link': notLinkController.text,
        },
        date: DateTime.now(),
        isActive: false,
        senderUserUID: FirebaseAuth.instance.currentUser!.uid,
        senderUserImage: currentShop!.image,
      );

      firestore.collection('notifications').add(notificationModule.toMap());

      KSnackBar.success('تم ارسال الاشعار بنجاح سيتم مراجعتة من قبل الادارة');
    } catch (e) {
      log(e);
    } finally {
      notTitleController.clear();
      notLinkController.clear();
      loading = false;
      update();
    }
  }

  void updateNotificationCard(int index) {
    update(['notification-card-$index']);
  }

  Future<void> getCurrentShop() async {
    loading = true;
    update();
    if (!isShop) {
      Get.back();
      return;
    }

    currentShop = await FirebaseFirestoreHelper.instance.getShopModule(
        FirebaseAuth.instance.currentUser!.uid,
        getSubscriptions: true);

    loading = false;
    update();
  }

  void showNotification(NotificationModule notification) {
    Get.dialog(Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              notification.title ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('نص الاشعار: ${notification.body}'),
            const SizedBox(height: 10),
            Text('تاريخ الارسال: ${notification.date}'),
          ],
        ),
      ),
    ));
  }

  @override
  void onInit() async {
    super.onInit();
    await getCurrentShop();
    initNoOfMonthlySend();
    await getNotifications();
  }
}
