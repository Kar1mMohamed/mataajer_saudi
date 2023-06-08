import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_account_controller.dart';
import 'package:mataajer_saudi/app/data/modules/send_notification_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/cloud_messaging.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';

class ShopCustomersNotificationsController extends GetxController {
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  final mainAccountController = Get.find<MainAccountController>();

  ShopModule? currentShop;

  bool get isShop => mainAccountController.isShopOwner;

  bool loading = true;

  final notTitleController = TextEditingController();

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
      bool isHasLimit = await CloudMessaging.checkIfUserHasLimit();

      if (!isHasLimit) {
        KSnackBar.error('لقد تجاوزت الحد الاقصى للارسال');
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
          title: 'اشعار من ${currentShop!.name}',
          body: notTitleController.text,
          token: 'for-all-fcm-tokens',
        );
      }).toList();

      final batch = firestore.batch();

      for (var i = 0; i < sendModules.length; i++) {
        batch.set(
          firestore.collection('notifications').doc(),
          sendModules[i].toMap(),
        );
      }

      await batch.commit();
      await CloudMessaging.increaseSentNumber(
          FirebaseAuth.instance.currentUser!.uid);

      KSnackBar.success('تم ارسال الاشعارات بنجاح');
    } catch (e) {
      print(e);
    } finally {
      loading = false;
      update();
    }
  }

  void getCurrentShop() async {
    loading = true;
    update();
    if (!isShop) {
      Get.back();
      return;
    }

    currentShop = await FirebaseFirestoreHelper.instance
        .getShopModule(FirebaseAuth.instance.currentUser!.uid);

    loading = false;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    getCurrentShop();
  }
}
