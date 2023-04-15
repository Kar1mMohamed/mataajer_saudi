import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/data/modules/send_notification_module.dart';
import 'package:mataajer_saudi/app/functions/cloud_messaging.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';

class ShopCustomersNotificationsController extends GetxController {
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  final mainAccountController = Get.find<MainAccountController>();

  bool get isShop => mainAccountController.isShopOwner;

  bool loading = false;

  final notTitleController = TextEditingController();

  Future<void> sendNotification() async {
    loading = true;
    update();
    try {
      if (notTitleController.text.isEmpty) {
        KSnackBar.error('من فضلك ادخل نص الاشعار');
        return;
      }
      List<String> allFCMTokens =
          await FirebaseFirestoreHelper.instance.getAllFCMTokens();
      print('allFCMTokens: $allFCMTokens');

      if (allFCMTokens.isEmpty) {
        print('allFCMTokens is empty');
        return;
      }

      bool isHasLimit = await CloudMessaging.checkIfUserHasLimit();

      if (!isHasLimit) {
        KSnackBar.error('لقد تجاوزت الحد الاقصى للارسال');
        return;
      }

      List<SendNotifictaionModule> sendModules = allFCMTokens.map((e) {
        return SendNotifictaionModule(
          title: notTitleController.text,
          body: notTitleController.text,
          token: e,
        );
      }).toList();

      final batch = firestore.batch();

      for (var i = 0; i < sendModules.length; i++) {
        await CloudMessaging.sendNotification(sendModules[i]);

        batch.set(
          firestore.collection('notifications').doc(),
          sendModules[i].toMap(),
        );
      }

      await batch.commit();

      KSnackBar.success('تم ارسال الاشعارات بنجاح');
    } catch (e) {
      print(e);
    } finally {
      loading = false;
      update();
    }
  }
}
