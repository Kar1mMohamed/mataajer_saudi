import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mataajer_saudi/app/controllers/main_notification_controller.dart';
import 'package:mataajer_saudi/app/data/modules/send_notification_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/functions/url_launcher.dart';
import 'package:mataajer_saudi/app/functions/uuid.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class CloudMessaging {
  CloudMessaging._();

  static const _cloudMessagingKey =
      'AAAAAZHRUrk:APA91bGvrCb7xr1_M8A1sFeaqetTmCy3xP1dgoLz7PHskiMgfLj34k8J2EHJ7KSPu6kYoNXJdBob93EEsj65cf420KIXJegzBTSYTD292Kgly3cAqvWKzOhf4fLr1yZB1TB7Kv6RSx8l';

  static Future<void> initialize() async {
    try {
      String? deviceUUID = GetStorage().read<String>('deviceUUID_v2');

      if (deviceUUID == null) {
        deviceUUID = UUIDFunctions.getDeviceUUID();
        await GetStorage().write('deviceUUID_v2', deviceUUID);
      }

      log('deviceUUID: $deviceUUID');

      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      log('User granted permission: ${settings.authorizationStatus}');

      sendFCMTokenToFirebase(deviceUUID); // TO SEND ANY VISITOR TO DATABASE

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        log('Got a message whilst in the foreground!');
        log('Message data: ${message.data}');

        if (message.notification != null) {
          final notificationController = Get.find<MainNotificationController>();
          notificationController.notificationCount.value++;
          notificationController.update();
          log('Message also contained a notification: (name: ${message.notification!.title}, body: ${message.notification!.body})');
        }
      });

      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        log('A new onMessageOpenedApp event was published!');
        log('Message data: ${message.data}');

        if (message.notification != null) {
          log('Message Opened App also contained a notification: (name: ${message.notification!.title}, body: ${message.notification!.body})');
          final notificationController = Get.find<MainNotificationController>();
          notificationController.notificationCount.value++;
          notificationController.update();
          URLLauncherFuntions.launchURL(message.data['link']);
        }
      });

      // initLocalNotifications();
    } catch (e) {
      log(e);
    }
  }

  // static void initLocalNotifications() async {
  //   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //       FlutterLocalNotificationsPlugin();
  //   flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           AndroidFlutterLocalNotificationsPlugin>()!
  //       .requestPermission();

  //   // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('app_icon');
  //   const DarwinInitializationSettings initializationSettingsDarwin =
  //       DarwinInitializationSettings();

  //   const InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: initializationSettingsAndroid,
  //     iOS: initializationSettingsDarwin,
  //   );

  //   await flutterLocalNotificationsPlugin.initialize(
  //     initializationSettings,
  //     // onDidReceiveNotificationResponse:
  //     //     (NotificationResponse notificationResponse) async {
  //     //   // ...
  //     // },
  //     onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  //   );
  // }

  static void sendFCMTokenToFirebase(String deviceUUID) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      log('token: $token');
      if (token == null) {
        throw Exception('Token is null');
      }

      await FirebaseFirestoreHelper.instance.sendFCMToken(token, deviceUUID);

      log('FCM Token sent to Firebase $token');
    } catch (e) {
      log('FCM Token sent to Firebase failed $e');
    }
  }

  static Future<bool> checkIfUserHasLimit(ShopModule shop) async {
    try {
      final now = DateTime.now();
      final userUID0 = shop.uid;
      final currentDateUID = '${now.year}-${now.month}';
      final noOfNotoficationUserCanSend = shop.noOfNotificationCandSend;

      var isHasLimit = await FirebaseFirestore.instance
          .collection('shops')
          .doc(userUID0)
          .collection('notifications')
          .doc(currentDateUID)
          .get()
          .then((value) {
        if (!value.exists) {
          return true; // if it's not exist so it's the first time to send
        }

        final data = value.data();
        final limit = data?['sent'];

        if (data == null || data.isEmpty || limit == null) {
          return true; // if it's not exist so it's the first time to send
        }

        // if (limit == null) {
        //   return true; // if it's not exist so it's the first time to send
        // }

        if (limit >= noOfNotoficationUserCanSend) {
          return false; // if it's > 3 so he has no limit to send
        } else if (limit < noOfNotoficationUserCanSend) {
          return true; // if it's < 3 so he has limit to send
        }

        return false; // by anything else so he has no limit to send
      });

      return isHasLimit;
    } catch (e) {
      log(e);
      return false;
    }
  }

  static Future<void> increaseSentNumber(String userUID, String dateUID) async {
    try {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(userUID)
          .collection('notifications')
          .doc(dateUID)
          .set({'sent': FieldValue.increment(1)}).onError(
        (error, stackTrace) async {
          if (error.toString().contains('not-found')) {
            FirebaseFirestore.instance
                .collection('shops')
                .doc(userUID)
                .collection('notifications')
                .doc(dateUID)
                .set({'sent': 1});
          }

          return;
        },
      );
    } catch (e) {
      log(e);
    }
  }

  static Future<void> decreaseSentNumber(String userUID, String dateUID) async {
    try {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(userUID)
          .collection('notifications')
          .doc(dateUID)
          .update({'sent': FieldValue.increment(-1)}).onError(
        (error, stackTrace) async {
          if (error.toString().contains('not-found')) {
            FirebaseFirestore.instance
                .collection('shops')
                .doc(userUID)
                .collection('notifications')
                .doc(dateUID)
                .set({'sent': 1});
          }

          return;
        },
      );
    } catch (e) {
      log(e);
    }
  }

  static Future<void> sendNotification(SendNotifictaionModule module) async {
    try {
      var options = Options(headers: {
        HttpHeaders.authorizationHeader: 'key=$_cloudMessagingKey'
      });

      var response = await Dio().post(
        'https://fcm.googleapis.com/fcm/send',
        options: options,
        data: module.requestToMap(),
      );

      if (response.statusCode == 200) {
        log('Notification sent successfully, token: ${module.token}');
      } else {
        log('Notification sent failed');
      }
    } catch (e) {
      log(e);
    }
  }
}
