import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mataajer_saudi/app/data/app/app_settings.dart';
import 'package:mataajer_saudi/app/data/modules/ad_module.dart';
import 'package:mataajer_saudi/app/data/modules/banner.dart';
import 'package:mataajer_saudi/app/data/modules/invoice_module.dart';
import 'package:mataajer_saudi/app/data/modules/offer_module.dart';
import 'package:mataajer_saudi/app/data/modules/shop_module.dart';
import 'package:mataajer_saudi/app/data/modules/subscribtion_module.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:mataajer_saudi/database/notification.dart';

import '../data/modules/pop_up_ad_module.dart';

class FirebaseFirestoreHelper {
  FirebaseFirestoreHelper._();

  static FirebaseFirestoreHelper instance = FirebaseFirestoreHelper._();

  Future<void> setAppSettings(AppSettings appSettings) async {
    try {
      await FirebaseFirestore.instance
          .collection('settings')
          .doc('app')
          .set(appSettings.toMap());
    } catch (e) {
      log(e);
    }
  }

  // getHomeBanners
  Future<List<BannerModule>> getHomeBanners() async {
    try {
      final banners = await FirebaseFirestore.instance
          .collection('app')
          .doc('home_view')
          .get()
          .then((value) {
        var list = value.data()?['banners'] as List;
        return list.map((e) => BannerModule.fromMap(e)).toList();
      });

      return banners;
    } catch (e) {
      log(e);
      rethrow;
    }
  }

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

  Future<ShopModule> getShopModule(String uid,
      {bool? getSubscriptions = true}) async {
    try {
      final profile = await FirebaseFirestore.instance
          .collection('shops')
          .doc(uid)
          .get()
          .then((value) {
        if (value.data() == null) {
          return null;
        }
        return ShopModule.fromMap(value.data()!, uid);
      });

      if (profile == null) {
        throw 'profile is null';
      }

      if ((getSubscriptions ?? false)) {
        await profile.getSubscriptions();
      }

      log('profile: ${profile.uid}');

      return profile;
    } catch (e) {
      log(e);
      rethrow;
    }
  }

  /// Return document uid
  Future<String?> addSubscription(
      String userUID, SubscriptionModule subModule) async {
    try {
      final res = await FirebaseFirestore.instance
          .collection('shops')
          .doc(userUID)
          .collection('subscriptions')
          .add(subModule.toMap());

      log('add subscription to $userUID, ${subModule.toMap()}');

      return res.id;
    } catch (e) {
      log(e);
      return null;
    }
  }

  Future<void> addInvoiceToShop(String? shopUID, InvoiceModule invoice) async {
    try {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(shopUID)
          .collection('invoices')
          .add(invoice.toMap());
    } catch (e) {
      log(e);
    }
  }

  Future<void> updateShop(ShopModule shopModule,
      {bool? updatePrivileges, bool? updateValidTill}) async {
    try {
      await Future.wait([
        if (updatePrivileges ?? false) shopModule.updatePrivileges(),
        if (updateValidTill ?? false) shopModule.updateValidTill(),
      ]);

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
      log(e);
      Get.defaultDialog(
        title: 'خطأ',
        middleText: "حدث خطأ أثناء إضافة المتجر",
      );
    }
  }

  Future<List<AdModule>> getAds({bool? forAdmin}) async {
    forAdmin ??= false;

    try {
      final collection = FirebaseFirestore.instance.collection('ads');

      if (forAdmin) {
        final ads = await collection.get().then((value) => value.docs
            .map((e) => AdModule.fromMap(e.data()..['uid'] = e.id))
            .toList());

        log('ads: ${ads.length}');

        return ads;
      } else {
        final ads = await collection
            .where('isVisible', isEqualTo: true)
            .where(
              'validTill',
              isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch,
            )
            .get()
            .then((value) => value.docs
                .map((e) => AdModule.fromMap(e.data()..['uid'] = e.id))
                .toList());

        log('ads: ${ads.length}');

        return ads;
      }
    } catch (e) {
      log(e);
      rethrow;
    }
  }

  Future<void> addOffer(OfferModule offer) async {
    try {
      await FirebaseFirestore.instance.collection('offers').add(offer.toMap());
    } catch (e) {
      log(e);
    }
  }

  Future<List<OfferModule>> getOffers({bool? forAdmin, int? limit}) async {
    forAdmin ??= false;

    try {
      final collection = FirebaseFirestore.instance.collection('offers');

      if (forAdmin) {
        final ads = await collection.get().then((value) => value.docs
            .map((e) => OfferModule.fromMap(e.data(), uid: e.id))
            .toList());

        log('offers: ${ads.length}');

        return ads;
      } else {
        final ads = await collection
            .where('isVisible', isEqualTo: true)
            .where('validTill',
                isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
            .get()
            .then((value) => value.docs
                .map((e) => OfferModule.fromMap(e.data(), uid: e.id))
                .toList());

        log('offers: ${ads.length}');

        // ads.forEach((element) {
        //   print('remainingDays: ${element.remainingDays}');
        // });

        return ads
            .where((element) => element.remainingDays > 0)
            .toList(); // return offers that valid at same day or greater
      }
    } catch (e) {
      log(e);
      rethrow;
    }
  }

  Future<List<ShopModule>> getShops(
      {bool? forAdmin, bool getSubscriptions = false}) async {
    forAdmin ??= false;
    try {
      var collection = FirebaseFirestore.instance.collection('shops');

      List<ShopModule> shops = [];

      if (forAdmin) {
        shops = await collection.get().then((value) =>
            value.docs.map((e) => ShopModule.fromMap(e.data(), e.id)).toList());

        if (getSubscriptions) {
          for (var shop in shops) {
            await shop.getSubscriptions();
          }
        }
      } else {
        shops = await collection
            .where('verified', isEqualTo: true)
            .where('isVisible', isEqualTo: true)
            .where(
              'validTill',
              isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch,
            )
            .get()
            .then((value) => value.docs
                .map((e) => ShopModule.fromMap(e.data(), e.id))
                .toList());
      }

      shops.removeWhere((element) {
        if (element.categories.isEmpty || element.categoriesUIDs.isEmpty) {
          log('removed shop ${element.uid}, ${element.name}');
          return true;
        } else {
          return false;
        }
      });

      log('shops: ${shops.length}');

      if (getSubscriptions) {
        for (var shop in shops) {
          await shop.getSubscriptions();
        }
      }

      return shops;
    } catch (e) {
      log(e);
      rethrow;
    }
  }

  Future<int> getShopsCount() async {
    try {
      final len = await FirebaseFirestore.instance
          .collection('shops')
          .get()
          .then((value) => value.docs.length);
      return len + 1;
    } catch (e) {
      log(e);
      rethrow;
    }
  }

  Future<List<InvoiceModule>> getShopInvoices(String shopUID) async {
    try {
      final invoices = await FirebaseFirestore.instance
          .collection('shops')
          .doc(shopUID)
          .collection('invoices')
          .get()
          .then((value) => value.docs
              .map((e) => InvoiceModule.fromMap(e.data(), uid: e.id))
              .toList());

      return invoices;
    } catch (e) {
      log(e);
      rethrow;
    }
  }

  void addHit(String collectionName, String uid, {int? toAdd}) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(uid)
          .update({'hits': FieldValue.increment(toAdd ?? 1)});

      log('hit added $uid');
    } catch (e) {
      log(e);
    }
  }

  Future<void> decreaseNotificationSent(
      String userUID, String dateYYYYM) async {
    try {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(userUID)
          .collection('notifications')
          .doc(dateYYYYM)
          .update({'sent': FieldValue.increment(-1)});
    } catch (e) {
      log('decreaseNotificationSent: $e');
    }
  }

  Future<int> getNotificationsSentCount(
      String userUID, String dateYYYYM) async {
    try {
      final count = await FirebaseFirestore.instance
          .collection('shops')
          .doc(userUID)
          .collection('notifications')
          .doc(dateYYYYM)
          .get()
          .then((value) => value.data()?['sent'] as int?);
      return count ?? 0;
    } catch (e) {
      log(e);
      return 0;
    }
  }

  Future<List<NotificationModule>> getUserNotifications(String userUID) async {
    try {
      var collection = FirebaseFirestore.instance
          .collection('notifications')
          .where('senderUserUID', isEqualTo: userUID)
          .get()
          .then((value) => value.docs
              .map((e) => NotificationModule.fromMap(e.data()))
              .toList());

      return collection;
    } catch (e) {
      log('getUserNotifications: $e');
      return [];
    }
  }

  Future<void> sendFCMToken(String token, String docUID) async {
    try {
      await FirebaseFirestore.instance
          .collection('fcm_tokens')
          .doc(docUID)
          .set({
        'token': token,
        'createdAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      await GetStorage().remove('fcm_token_uid');
      log(e);
      rethrow;
    }
  }

  Future<List<NotificationModule>> getAllNotifications(
      {bool? isActive, bool? forAdmin}) async {
    var collection = FirebaseFirestore.instance.collection('notifications');
    var result = <NotificationModule>[];
    try {
      if (forAdmin ?? false) {
        result = await collection.get().then((value) => value.docs
            .map((e) => NotificationModule.fromMap(e.data(), docUID: e.id))
            .toList());
      } else {
        result = await collection
            .where('isActive', isEqualTo: isActive ?? true)
            .get()
            .then((value) => value.docs
                .map((e) => NotificationModule.fromMap(e.data(), docUID: e.id))
                .toList());
      }
      log('notifications: ${result.length}');

      return result;
    } catch (e) {
      log(e);
      throw e.toString();
    }
  }

  Future<List<NotificationModule>> getShopNotifications(String shopUID) async {
    try {
      final res = await FirebaseFirestore.instance
          .collection('notifications')
          .where('senderUserUID', isEqualTo: shopUID)
          .get()
          .then((value) => value.docs
              .map((e) => NotificationModule.fromMap(e.data(), docUID: e.id))
              .toList());

      log('notifications: ${res.length}');

      return res;
    } catch (e) {
      log('getShopNotifications: $e');
      rethrow;
    }
  }

  Future<void> sendNotificationToFirebase(NotificationModule module) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .add(module.toMap());
    } catch (e) {
      log(e);
    }
  }

  Future<void> deleteNotification(NotificationModule notification) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notification.docUID)
          .delete();
    } catch (e) {
      log(e);
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
      log(e);
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
      log(e);
      rethrow;
    }
  }

  Future<void> updateShopVerification(ShopModule module) async {
    try {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(module.uid)
          .update({'verified': module.verified});

      log('updated shop verification: ${module.verified}, ${module.uid}');
    } catch (e) {
      log(e);
      rethrow;
    }
  }

  Future<void> updatePopUpAdVisibility(PopUpAdModule module) async {
    try {
      await FirebaseFirestore.instance
          .collection('pop_up_ads')
          .doc(module.uid)
          .update({'isVisible': module.isVisible});
    } catch (e) {
      log(e);
      rethrow;
    }
  }

  Future<void> updatePopUpAd(PopUpAdModule module) async {
    try {
      await FirebaseFirestore.instance
          .collection('pop_up_ads')
          .doc(module.uid)
          .update(module.toMap());
    } catch (e) {
      log(e);
      rethrow;
    }
  }

  Future<void> updateOfferVisibility(OfferModule offer) async {
    try {
      await FirebaseFirestore.instance
          .collection('offers')
          .doc(offer.uid)
          .update({'isVisible': offer.isVisible});
    } catch (e) {
      log(e);
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

  // Future<void> deleteAd(AdModule ad) async {
  //   try {
  //     if (ad.uid == null) {
  //       throw 'docUID is null';
  //     }
  //     await FirebaseFirestore.instance.collection('ads').doc(ad.uid).delete();
  //   } catch (e) {
  //     log(e);
  //   }
  // }

  Future<void> deleteShop(ShopModule shop) async {
    try {
      if (shop.uid == null) {
        throw 'docUID is null';
      }
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(shop.uid)
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

  Future<void> addPopUpAd(PopUpAdModule ad) async {
    try {
      await FirebaseFirestore.instance.collection('pop_up_ads').add(ad.toMap());
    } catch (e) {
      log(e);
    }
  }

  Future<List<PopUpAdModule>> getPopUpAds({bool? forAdmin}) async {
    forAdmin ??= false;
    try {
      final collection = FirebaseFirestore.instance.collection('pop_up_ads');

      if (forAdmin) {
        final ads = await collection.get().then((value) => value.docs
            .map((e) => PopUpAdModule.fromMap(e.data(), uid: e.id))
            .toList());

        log('popup ads: ${ads.length}');

        return ads;
      } else {
        final ads = await collection
            .where('isVisible', isEqualTo: true)
            .where(
              'validTill',
              isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch,
            )
            .get()
            .then((value) => value.docs
                .map((e) => PopUpAdModule.fromMap(e.data(), uid: e.id))
                .toList());

        log('popup ads: ${ads.length}');

        return ads;
      }
    } catch (e) {
      log(e);
      throw e.toString();
    }
  }

  Future<List<OfferModule>> getShopOffers(String shopUID) async {
    try {
      final offers = await FirebaseFirestore.instance
          .collection('offers')
          .where('shopUID', isEqualTo: shopUID)
          .get()
          .then((value) => value.docs
              .map((e) => OfferModule.fromMap(e.data(), uid: e.id))
              .toList());

      log('offers: ${offers.length}');

      return offers;
    } catch (e) {
      log(e);
      throw e.toString();
    }
  }

  Future<List<PopUpAdModule>> getShopPopUpAds(String shopUID) async {
    try {
      final ads = await FirebaseFirestore.instance
          .collection('pop_up_ads')
          .where('shopUID', isEqualTo: shopUID)
          .get()
          .then((value) => value.docs
              .map((e) => PopUpAdModule.fromMap(e.data(), uid: e.id))
              .toList());

      log('popup ads: ${ads.length}');

      return ads;
    } catch (e) {
      log(e);
      throw e.toString();
    }
  }

  Future<void> deletePopUpAd(String adUID) async {
    try {
      await FirebaseFirestore.instance
          .collection('pop_up_ads')
          .doc(adUID)
          .delete();
    } catch (e) {
      log(e);
    }
  }

  Future<void> deleteOffer(OfferModule offer) async {
    try {
      if (offer.uid == null) {
        throw 'docUID is null';
      }
      await FirebaseFirestore.instance
          .collection('offers')
          .doc(offer.uid)
          .delete();
    } catch (e) {
      log(e);
    }
  }

  Future<void> updateUserSubscription(
      String userUID, String subUID, SubscriptionModule module) async {
    try {
      await FirebaseFirestore.instance
          .collection('shops')
          .doc(userUID)
          .collection('subscriptions')
          .doc(subUID)
          .update(module.toMap());
    } catch (e) {
      log(e);
    }
  }
}
