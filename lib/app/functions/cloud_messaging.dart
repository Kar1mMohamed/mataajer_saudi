import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mataajer_saudi/app/data/modules/send_notification_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

import '../../database/notification.dart';
import '../../main.dart';

class CloudMessaging {
  CloudMessaging._();

  static Map<String, dynamic> sentData = {
    'isSent': false,
    'sentDate': '',
    'token': '',
    'docUID': '',
  };

  static const _cloudMessagingKey =
      'AAAAAZHRUrk:APA91bGvrCb7xr1_M8A1sFeaqetTmCy3xP1dgoLz7PHskiMgfLj34k8J2EHJ7KSPu6kYoNXJdBob93EEsj65cf420KIXJegzBTSYTD292Kgly3cAqvWKzOhf4fLr1yZB1TB7Kv6RSx8l';

  static Future<void> initialize() async {
    try {
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

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        log('Got a message whilst in the foreground!');
        log('Message data: ${message.data}');

        if (message.notification != null) {
          log('Message also contained a notification: (name: ${message.notification!.title}, body: ${message.notification!.body})');

          final notificationModule = NotificationModule(
            title: message.notification?.title ?? '',
            body: message.notification?.body ?? '',
            data: message.data,
            date: DateTime.now(),
          );
          await NotificationModule.hiveBox.add(notificationModule);
        }
      });

      // initLocalNotifications();

      sendFCMTokenToFirebase(); // TO SEND ANY VISITOR TO DATABASE
    } catch (e) {
      print(e);
    }
  }

  static void initLocalNotifications() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestPermission();

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // onDidReceiveNotificationResponse:
      //     (NotificationResponse notificationResponse) async {
      //   // ...
      // },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static void sendFCMTokenToFirebase() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print('token: $token');
      if (token == null) {
        throw Exception('Token is null');
      }

      await FirebaseFirestoreHelper.instance.sendFCMToken(token);

      print('FCM Token sent to Firebase $token');
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> checkIfUserHasLimit({String? userUID}) async {
    try {
      final now = DateTime.now();
      final userUID0 = userUID ?? FirebaseAuth.instance.currentUser!.uid;
      final currentDateUID = '${now.year}-${now.month}';

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
        if (data == null) {
          return true; // if it's not exist so it's the first time to send
        }

        final limit = data['sent'];
        if (limit == null) {
          return true; // if it's not exist so it's the first time to send
        }

        if (limit > 3) {
          return false; // if it's > 3 so he has no limit to send
        } else if (limit < 3) {
          return true; // if it's < 3 so he has limit to send
        }

        return false; // by anything else so he has no limit to send
      });

      return isHasLimit;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> increaseSentNumber(String userUID) async {
    try {
      final now = DateTime.now();
      final currentDateUID = '${now.year}-${now.month}';
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(userUID)
          .collection('notifications')
          .doc(currentDateUID)
          .update({'sent': FieldValue.increment(1)}).onError(
        (error, stackTrace) async {
          if (error.toString().contains('not-found')) {
            FirebaseFirestore.instance
                .collection('shops')
                .doc(userUID)
                .collection('notifications')
                .doc(currentDateUID)
                .set({'sent': 1});
          }

          return;
        },
      );
    } catch (e) {
      print(e);
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
      print(e);
    }
  }
}
