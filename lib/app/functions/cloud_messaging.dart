import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mataajer_saudi/app/data/modules/send_notification_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';

class CloudMessaging {
  CloudMessaging._();

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

      print('User granted permission: ${settings.authorizationStatus}');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      });

      CloudMessaging
          .sendFCMTokenToFirebase(); // TO SEND ANY VISITOR TO DATABASE
    } catch (e) {
      print(e);
    }
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

  static Future<bool> checkIfUserHasLimit() async {
    try {
      final now = DateTime.now();
      final userUID = FirebaseAuth.instance.currentUser!.uid;
      final currentDateUID = '${now.year}-${now.month}';
      var isHasLimit = await FirebaseFirestore.instance
          .collection('shops')
          .doc(userUID)
          .collection('notifications')
          .doc(currentDateUID)
          .get()
          .then((value) {
        if (!value.exists) {
          return true;
        }

        final data = value.data();
        if (data == null) {
          return true;
        }

        final limit = data['sent'];
        if (limit == null) {
          return true;
        }

        if (limit > 3) {
          return false;
        } else if (limit < 3) {
          return true;
        }

        return false;
      });

      return isHasLimit;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> increaseSentNumber() async {
    try {
      final now = DateTime.now();
      final userUID = FirebaseAuth.instance.currentUser!.uid;
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
        data: module.toMap(),
      );

      if (response.statusCode == 200) {
        await increaseSentNumber();
        print('Notification sent successfully');
      } else {
        print('Notification sent failed');
      }
    } catch (e) {
      print(e);
    }
  }
}
