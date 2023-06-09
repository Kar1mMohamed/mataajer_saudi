import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/data/modules/subscribtion_module.dart';
import 'package:mataajer_saudi/app/functions/cloud_messaging.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:mataajer_saudi/database/notification.dart';

class FirebaseFirestoreHelper {
  FirebaseFirestoreHelper._();

  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper._();

  Future<void> addShop(ShopModule shopModule, String userUID) async {
    try {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(userUID)
          .set(shopModule.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<ShopModule> getShopModule(String uid) async {
    try {
      final profile = await FirebaseFirestore.instance
          .collection('shops')
          .doc(uid)
          .get()
          .then((value) => ShopModule.fromMap(value.data()!, uid));

      final subscriptions = await FirebaseFirestore.instance
          .collection('shops')
          .doc(uid)
          .collection('subscriptions')
          .get()
          .then((value) => value.docs
              .map((e) => SubscriptionModule.fromMap(e.data()))
              .toList());

      profile.subscriptions = subscriptions;

      log('profile: ${profile.toJson()}');

      return profile;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> addSubscription(
      String userUID, SubscriptionModule subModule) async {
    try {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(userUID)
          .collection('subscriptions')
          .add(subModule.toMap());

      log('add subscription to $userUID, ${subModule.toJson()}');
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateShop(ShopModule shopModule) async {
    try {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(shopModule.uid)
          .update(shopModule.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> adShopAdd(AdModule module) async {
    try {
      await FirebaseFirestore.instance.collection('ads').add(module.toMap());
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: 'خطأ',
        middleText: "حدث خطأ أثناء إضافة المتجر",
      );
    }
  }

  Future<List<AdModule>> getAds() async {
    try {
      final ads = await FirebaseFirestore.instance
          .collection('ads')
          .where('isVisible', isEqualTo: true)
          .where('validTill',
              isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
          .get()
          .then((value) => value.docs
              .map((e) => AdModule.fromMap(e.data()..['uid'] = e.id))
              .toList());

      log('ads: ${ads.length}');

      return ads;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<ShopModule>> getShops() async {
    try {
      final shops = await FirebaseFirestore.instance
          .collection('shops')
          .get()
          .then((value) => value.docs
              .map((e) => ShopModule.fromMap(e.data(), e.id))
              .toList());

      shops.removeWhere((element) => element.userCategory != null);

      return shops;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  void addHit(String adUID) async {
    try {
      await FirebaseFirestore.instance
          .collection('ads')
          .doc(adUID)
          .update({'hits': FieldValue.increment(1)});

      log('hit added $adUID');
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendFCMToken(String token) async {
    bool isAlreadySent = CloudMessaging.sentData['isSent'] ?? false;

    try {
      bool isUser = FirebaseAuth.instance.currentUser != null;
      if (isAlreadySent) {
        log('token already sent');
      } else if (isUser) {
        final userUID = FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance
            .collection('fcm_tokens')
            .doc('user_$userUID')
            .set({
          'token': token,
          'createdAt': DateTime.now().toIso8601String(),
        });
        CloudMessaging.sentData['isSent'] = true;
        CloudMessaging.sentData['sentDate'] = DateTime.now().toIso8601String();
        CloudMessaging.sentData['token'] = token;
        CloudMessaging.sentData['docUID'] = 'user_$userUID';
      } else {
        final res =
            await FirebaseFirestore.instance.collection('fcm_tokens').add({
          'token': token,
          'createdAt': DateTime.now().toIso8601String(),
        });
        CloudMessaging.sentData['isSent'] = true;
        CloudMessaging.sentData['sentDate'] = DateTime.now().toIso8601String();
        CloudMessaging.sentData['token'] = token;
        CloudMessaging.sentData['docUID'] = res.id;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<NotificationModule>> getAllNotifications({bool? isActive}) async {
    try {
      final res = await FirebaseFirestore.instance
          .collection('notifications')
          .where('isActive', isEqualTo: isActive ?? true)
          .get()
          .then((value) => value.docs
              .map((e) => NotificationModule.fromMap(e.data(), docUID: e.id))
              .toList());

      log('notifications: ${res.length}');

      return res;
    } catch (e) {
      log(e);
      throw e.toString();
    }
  }

  Future<void> sendNotificationToFirebase(NotificationModule module) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .add(module.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<List<String>> getAllFCMTokens() async {
    try {
      final tokens = await FirebaseFirestore.instance
          .collection('fcm_tokens')
          .get()
          .then((value) =>
              value.docs.map((e) => e.data()['token'] as String).toList());

      return tokens;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateShopVisiblity(ShopModule module) async {
    try {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(module.uid)
          .update({'isVisible': module.isVisible});
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteShop(ShopModule module) async {
    try {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(module.uid)
          .delete();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteNotifications(NotificationModule module) async {
    try {
      if (module.docUID == null) {
        throw 'docUID is null';
      }
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(module.docUID)
          .delete();
    } catch (e) {
      log(e);
    }
  }

  Future<void> updateNotification(NotificationModule module) async {
    try {
      if (module.docUID == null) {
        throw 'docUID is null';
      }
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(module.docUID)
          .update(module.toMap());
    } catch (e) {
      log(e);
    }
  }

  Future<void> acceptNotification(NotificationModule module) async {
    try {
      if (module.docUID == null) {
        throw 'docUID is null';
      }
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(module.docUID)
          .update({'isActive': true});
    } catch (e) {
      log(e);
    }
  }
}
