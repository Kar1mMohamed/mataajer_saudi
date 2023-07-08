import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

      final notificationModule = NotificationModule(
        title: 'اشعار من ${currentShop!.name}',
        body: notTitleController.text,
        data: {},
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

    currentShop = await FirebaseFirestoreHelper.instance.getShopModule(
        FirebaseAuth.instance.currentUser!.uid,
        getSubscriptions: true);

    loading = false;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    getCurrentShop();
  }
}
