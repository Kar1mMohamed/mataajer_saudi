// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/subscribtion_module.dart';
import 'package:mataajer_saudi/app/functions/firebase_firestore.dart';
import 'package:mataajer_saudi/app/functions/payments_helper.dart';
import 'package:mataajer_saudi/app/modules/home/controllers/home_controller.dart';
import 'package:mataajer_saudi/app/theme/theme.dart';
import 'package:mataajer_saudi/app/utils/log.dart';
import 'package:mataajer_saudi/app/widgets/check_out_webview.dart';
import 'package:mataajer_saudi/utils/ksnackbar.dart';

import '../../modules/ChooseSubscription/views/choose_subscription_view.dart';
import 'choose_subscription_module.dart';
import 'tap/tap_charge_req.dart';

class ShopModule {
  String? uid;
  String name;
  String? email;
  String? phone;
  String description;
  String image;
  double? avgShippingPrice;
  String? avgShippingTime;
  String? cuponText;
  String? cuponCode;
  List<String> categoriesUIDs = [];
  List<SubscriptionModule>? subscriptions;
  String? shopLink;
  List<String>? keywords = [];
  bool? isVisible;
  String? userCategory;
  int? hits;
  //
  bool? isStaticAd = false;
  bool? isTwoPopUpAdsMonthly = false;
  bool? isFourPopUpAdsMonthly = false;
  bool? isCanSendNotification = false;
  DateTime? validTill;
  //
  ShopModule({
    this.uid,
    required this.name,
    this.email,
    this.phone,
    required this.description,
    required this.image,
    this.avgShippingPrice,
    this.avgShippingTime,
    this.cuponText,
    this.cuponCode,
    required this.categoriesUIDs,
    this.subscriptions,
    this.shopLink,
    this.keywords,
    this.isVisible,
    this.userCategory,
    this.hits,
    this.isStaticAd,
    this.isTwoPopUpAdsMonthly,
    this.isFourPopUpAdsMonthly,
    this.isCanSendNotification,
    this.validTill,
  });

  bool get isMostVisitShop {
    try {
      final allShops = Get.find<HomeController>().shops;
      final shops = allShops
          .where((element) => element.categoriesUIDs.contains(uid))
          .toList()
        ..sort((a, b) => b.hits?.compareTo(a.hits ?? 0) ?? 0);

      if (shops.isEmpty) return false;

      final bestShops = shops.take(20);

      bool isCurrentShopInsideBsetShops =
          bestShops.where((element) => element.uid == uid).toList().isNotEmpty;

      return isCurrentShopInsideBsetShops;
    } catch (e) {
      log('isMostVisitAd error: $e');
      return false;
    }
    // return true; // Temprory true untill do it as logic
  }

  bool get isMostOffers {
    try {
      final allOffers = Get.find<HomeController>().offers;
      final offers = allOffers
          .where((element) => element.shopUID == uid)
          .toList()
        ..sort((a, b) => b.hits?.compareTo(a.hits ?? 0) ?? 0);

      if (offers.isEmpty) return false;

      final bestOffers = offers.take(20);

      bool isCurrentOfferInsideBsetShops =
          bestOffers.where((element) => element.uid == uid).toList().isNotEmpty;

      return isCurrentOfferInsideBsetShops;
    } catch (e) {
      log('isMostOffers error: $e');
      return false;
    }
    // return true; // Temprory true untill do it as logic
  }

  bool get isOtherAd {
    if ((isStaticAd ?? false) || isMostOffers || isMostOffers) {
      return false;
    } else {
      return true;
    }
  }

  bool get isSubscriptionExpired {
    if (subscriptions == null || subscriptions!.isEmpty) return true;
    final lastSub = subscriptions!.last;
    return isExpired(lastSub.from, lastSub.to);
  }

  static bool isExpired(DateTime from, DateTime to) {
    final now = DateTime.now();

    if (now.isAfter(to) && now.isAfter(from)) {
      // is after end date and after start date (start - end - now)
      log('isExpired is after end date and after start date (start - end - now)');
      return true;
    } else if (now.isBefore(from) || now.isAfter(to)) {
      log('isExpired is before start date or after end date (now - start - end)');
      // is before start date or after end date (now - start - end)
      return true;
    }

    log('isExpired is not expired');
    return false;
  }

  List<CategoryModule> get categories {
    final maincategories = Get.find<MainSettingsController>().mainCategories;
    final categories = maincategories
        .where((element) => categoriesUIDs.contains(element.uid))
        .toList();

    return categories;
  }

  bool get canSendNotification {
    if (subscriptions == null || subscriptions!.isEmpty) {
      log('subscriptions is null or empty');
      return false;
    }

    final lastSub = subscriptions!.last;

    if (isExpired(lastSub.from, lastSub.to)) {
      log('subscription is expired');
      return false;
    }

    final lastSubscriptionUID = lastSub.subscriptionUID;
    final subscriptionSetting = MainSettingsController.find.subscriptions
        .firstWhereOrNull((element) => element.uid == lastSubscriptionUID);

    if (subscriptionSetting == null) {
      log('subscription is null');
      return false;
    }

    final isSubscriptionCanSendNotification =
        subscriptionSetting.isCanSendNotification;

    log('isSubscriptionCanSendNotification: $isSubscriptionCanSendNotification');

    return isSubscriptionCanSendNotification ?? false;
  }

  int get remainingDaysForSubscription {
    if (subscriptions == null || subscriptions!.isEmpty) {
      log('subscriptions is null or empty');
      return 0;
    }

    final lastSub = subscriptions!.last;
    if (isExpired(lastSub.from, lastSub.to)) {
      log('subscription is expired');
      return 0;
    }

    final lastSubscriptionUID = lastSub.subscriptionUID;
    final subscription = MainSettingsController.find.subscriptions
        .firstWhereOrNull((element) => element.uid == lastSubscriptionUID);

    if (subscription == null || subscription.allowedDays == null) {
      log('subscription is null');
      return 0;
    }

    return subscription.allowedDays! -
        DateTime.now().difference(lastSub.from).inDays;
  }

  // DateTime get validTill =>
  //     DateTime.now().add(Duration(days: remainingDaysForSubscription));

  Future<ChooseSubscriptionModule?> renewSubscription() async {
    if (FirebaseAuth.instance.currentUser == null) {
      KSnackBar.error('عقواً برجاء التأكد من تسجيل الدخول');
      return null;
    }
    try {
      final res = await Get.dialog(
        ChooseSubscriptionView(),
        barrierDismissible: false,
      );

      if (res is Map && res['status'] == 'success') {
        Get.dialog(MataajerTheme.loadingWidget, barrierDismissible: false);
        log('res from sub: $res');
        final resData = res['data'] as ChooseSubscriptionModule;

        final tapModule = TapChargeReq(
          amount: resData.getPriceByDays,
          description:
              'mataajer-sa subscription for ${resData.name} - ${FirebaseAuth.instance.currentUser?.uid} - ${resData.allowedDays}',
          currency: 'SAR',
          customer: Customer(
            firstName: name,
            email: email,
          ),
        );

        final paymentReqRes = await PaymentsHelper.sendRequest(tapModule);

        final id = paymentReqRes['id'];
        final redirectURL = paymentReqRes['transaction']['url'];

        Get.back();

        final paymentRes = await Get.to(
          () => CheckoutWebview(
            redirectURL,
            'mataajer://m.mataajer-sa.com/success',
            'mataajer://m.mataajer-sa.com/failed',
            'mataajer://m.mataajer-sa.com/cancel',
            onPaymentSuccess: (query) async {
              log('success query: $query');

              final isPaid = await PaymentsHelper.checkIFPaid(id);

              if (!isPaid) {
                KSnackBar.error('حدث خطأ ما الرجاء المحاولة مرة أخرى');
                Get.back(result: {
                  'status': 'failed',
                });
                return;
              }

              Get.back(result: {
                'status': 'success',
                'data': query,
              });
            },
            onPaymentCanceled: () {
              Get.back(result: {
                'status': 'canceled',
              });
            },
            onPaymentFailed: () {
              Get.back(result: {
                'status': 'failed',
              });
            },
          ),
        ) as Map<String, dynamic>;

        if (paymentRes['status'] != 'success') {
          log('paymentReqRes: $paymentReqRes');
          throw Exception('paymentReqRes: $paymentReqRes');
        }

        await FirebaseFirestoreHelper.instance.addSubscription(
          uid!,
          SubscriptionModule(
            from: DateTime.now(),
            to: DateTime.now().add(Duration(days: resData.allowedDays!)),
            subscriptionUID: resData.uid!,
          ),
        );

        await updateValidTill();
        await updatePrivileges();

        return resData;
      } else {
        return null;
      }
    } catch (e) {
      log(e);
      return null;
    }
  }

  Future<void> updatePrivileges() async {
    try {
      await getSubscriptions();
      if (subscriptions == null || subscriptions!.isEmpty) return;

      final currentSubscription = subscriptions!.last;

      final isCurrentSubscriptionExpired = isExpired(
        currentSubscription.from,
        currentSubscription.to,
      );

      if (isCurrentSubscriptionExpired) {
        log('subscription is expired');
        isStaticAd = false;
        this.isCanSendNotification = false;
        this.isFourPopUpAdsMonthly = false;
        this.isTwoPopUpAdsMonthly = false;
        return;
      }

      final subscriptionSettings = MainSettingsController.find.subscriptions
          .firstWhereOrNull(
              (element) => element.uid == currentSubscription.subscriptionUID);

      bool isStatic = subscriptionSettings?.isStatic ?? false;
      bool isCanSendNotification =
          subscriptionSettings?.isCanSendNotification ?? false;
      bool isFourPopUpAdsMonthly =
          subscriptionSettings?.isFourPopUpAdsMonthly ?? false;
      bool isTwoPopUpAdsMonthly =
          subscriptionSettings?.isTwoPopUpAdsMonthly ?? false;

      isStaticAd = isStatic;
      this.isCanSendNotification = isCanSendNotification;
      this.isFourPopUpAdsMonthly = isFourPopUpAdsMonthly;
      this.isTwoPopUpAdsMonthly = isTwoPopUpAdsMonthly;

      await FirebaseFirestoreHelper.instance.updateShop(this);
    } catch (e) {
      log(e);
    }
  }

  // Future<void> changeAllAdsVisibility(bool isVisible) async {
  //   try {
  //     final ads = await FirebaseFirestore.instance
  //         .collection('ads')
  //         .where('shopUID', isEqualTo: uid)
  //         .get();

  //     final batch = FirebaseFirestore.instance.batch();

  //     for (var e in ads.docs) {
  //       log('update visible for ad ${e.id}');
  //       batch.update(e.reference, {'isVisible': isVisible});
  //     }

  //     await batch.commit();

  //     log('updated visibility $isVisible for all ads $uid');
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> renewAllAdsAndPopUps() async {
    await getSubscriptions();

    try {
      final newAllowedDays = remainingDaysForSubscription;

      // final ads = await FirebaseFirestore.instance
      //     .collection('ads')
      //     .where('shopUID', isEqualTo: uid)
      //     .get();

      final popUpAds = await FirebaseFirestore.instance
          .collection('popUpAds')
          .where('shopUID', isEqualTo: uid)
          .get();

      final offers = await FirebaseFirestore.instance
          .collection('offers')
          .where('shopUID', isEqualTo: uid)
          .get();

      final batch = FirebaseFirestore.instance.batch();

      // for (var e in ads.docs) {
      //   log('update visible for ad ${e.id}');
      //   batch.update(e.reference, {
      //     'isVisible': true,
      //     'validTill': DateTime.now().add(Duration(days: newAllowedDays)),
      //   });
      // }

      for (var e in popUpAds.docs) {
        log('update visible for popUpAd ${e.id}');
        batch.update(e.reference, {
          'isVisible': true,
          'validTill': DateTime.now().add(Duration(days: newAllowedDays)),
        });
      }

      for (var e in offers.docs) {
        log('update visible for offer ${e.id}');
        batch.update(e.reference, {
          'isVisible': true,
          'validTill': DateTime.now().add(Duration(days: newAllowedDays)),
        });
      }

      await batch.commit();
    } catch (e) {
      log(e);
    }
  }

  /// GET SUBSCRIPTIONS FROM FIREBASE
  Future<void> getSubscriptions() async {
    try {
      final subscriptions = await FirebaseFirestore.instance
          .collection('shops')
          .doc(uid)
          .collection('subscriptions')
          .get()
          .then((value) => value.docs
              .map((e) => SubscriptionModule.fromMap(e.data()))
              .toList());

      log('shop subscriptions: ${subscriptions.map((e) => e.toMap()).toList()}');

      this.subscriptions = subscriptions;
    } catch (e) {
      log(e);
    }
  }

  Future<void> updateValidTill() async {
    try {
      await getSubscriptions();

      final newAllowedDays = remainingDaysForSubscription;
      final validTill = DateTime.now().add(Duration(days: newAllowedDays));
      this.validTill = validTill;

      await FirebaseFirestoreHelper.instance.updateShop(this);
      await updateShopServicesValidTill();
    } catch (e) {
      log('updateValidTill ${toJson()}');
    }
  }

  Future<void> updateShopServicesValidTill() async {
    try {
      final newAllowedDays = remainingDaysForSubscription;
      final validTill = DateTime.now().add(Duration(days: newAllowedDays));

      final offers = await FirebaseFirestore.instance
          .collection('offers')
          .where('shopUID', isEqualTo: uid)
          .get();

      final popUpAds = await FirebaseFirestore.instance
          .collection('pop_up_ads')
          .where('shopUID', isEqualTo: uid)
          .get();

      final batch = FirebaseFirestore.instance.batch();

      for (var e in offers.docs) {
        log('update validTill for offer ${e.id}');
        batch.update(e.reference, {'validTill': validTill});
      }

      for (var e in popUpAds.docs) {
        log('update validTill for pop up ad ${e.id}');
        batch.update(e.reference, {'validTill': validTill});
      }

      await batch.commit();
    } catch (e) {
      log(e);
    }
  }

  ShopModule copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? description,
    String? image,
    double? avgShippingPrice,
    String? avgShippingTime,
    String? cuponText,
    String? cuponCode,
    List<String>? categoriesUIDs,
    List<SubscriptionModule>? subscriptions,
    String? shopLink,
    List<String>? keywords,
    bool? isVisible,
    String? userCategory,
    int? hits,
    bool? isStaticAd,
    bool? isTwoPopUpAdsMonthly,
    bool? isFourPopUpAdsMonthly,
    bool? isCanSendNotification,
    DateTime? validTill,
  }) {
    return ShopModule(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      description: description ?? this.description,
      image: image ?? this.image,
      avgShippingPrice: avgShippingPrice ?? this.avgShippingPrice,
      avgShippingTime: avgShippingTime ?? this.avgShippingTime,
      cuponText: cuponText ?? this.cuponText,
      cuponCode: cuponCode ?? this.cuponCode,
      categoriesUIDs: categoriesUIDs ?? this.categoriesUIDs,
      subscriptions: subscriptions ?? this.subscriptions,
      shopLink: shopLink ?? this.shopLink,
      keywords: keywords ?? this.keywords,
      isVisible: isVisible ?? this.isVisible,
      userCategory: userCategory ?? this.userCategory,
      hits: hits ?? this.hits,
      isStaticAd: isStaticAd ?? this.isStaticAd,
      isTwoPopUpAdsMonthly: isTwoPopUpAdsMonthly ?? this.isTwoPopUpAdsMonthly,
      isFourPopUpAdsMonthly:
          isFourPopUpAdsMonthly ?? this.isFourPopUpAdsMonthly,
      isCanSendNotification:
          isCanSendNotification ?? this.isCanSendNotification,
      validTill: validTill ?? this.validTill,
    );
  }

  Map<String, dynamic> toMap({bool? forSignUp}) {
    return <String, dynamic>{
      // 'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'description': description,
      'image': image,
      'avgShippingPrice': avgShippingPrice,
      'avgShippingTime': avgShippingTime,
      'cuponText': cuponText,
      'cuponCode': cuponCode,
      'categoriesUIDs': categoriesUIDs,

      /// DONT POST SUBSCRIPTIONS TO SHOP DOCUMENT
      // 'subscriptions': (forSignUp ?? false)
      //     ? []
      //     : subscriptions.map((x) => x.toMap()).toList(),
      'shopLink': shopLink,
      'keywords': keywords,
      'isVisible': isVisible,
      if (userCategory != null) 'userCategory': userCategory,
      'hits': hits,
      'isStaticAd': isStaticAd,
      'validTill': validTill,
      'isCanSendNotification': isCanSendNotification,
      'isTwoPopUpAdsMonthly': isTwoPopUpAdsMonthly,
      'isFourPopUpAdsMonthly': isFourPopUpAdsMonthly,
    };
  }

  factory ShopModule.fromMap(Map<String, dynamic> map, String uid) {
    return ShopModule(
      uid: uid,
      name: map['name'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      description: map['description'] as String,
      image: map['image'] as String,
      avgShippingPrice: map['avgShippingPrice'] != null
          ? map['avgShippingPrice'] as double
          : null,
      avgShippingTime: map['avgShippingTime'] != null
          ? map['avgShippingTime'] as String
          : null,
      cuponText: map['cuponText'] != null ? map['cuponText'] as String : null,
      cuponCode: map['cuponCode'] != null ? map['cuponCode'] as String : null,
      categoriesUIDs: List<String>.from(
        (map['categoriesUIDs'] as List<dynamic>)
            .map<String>((x) => x as String),
      ),
      subscriptions: map['subscriptions'] != null
          ? List<SubscriptionModule>.from(
              (map['subscriptions'] as List<dynamic>).map<SubscriptionModule>(
                (x) => SubscriptionModule.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      shopLink: map['shopLink'] != null ? map['shopLink'] as String : null,
      keywords: map['keywords'] != null
          ? List<String>.from(
              (map['keywords'] as List<dynamic>)
                  .map<String>((x) => x as String),
            )
          : [],
      isVisible: map['isVisible'] != null ? map['isVisible'] as bool : false,
      userCategory:
          map['userCategory'] != null ? map['userCategory'] as String : null,
      hits: map['hits'] != null ? map['hits'] as int : 0,
      isStaticAd: map['isStaticAd'] != null ? map['isStaticAd'] as bool : false,
      validTill: map['validTill'] != null
          ? (map['validTill'] as Timestamp).toDate()
          : null,
      isCanSendNotification: map['isCanSendNotification'] != null
          ? map['isCanSendNotification'] as bool
          : false,
      isFourPopUpAdsMonthly: map['isFourPopUpAdsMonthly'] != null
          ? map['isFourPopUpAdsMonthly'] as bool
          : false,
      isTwoPopUpAdsMonthly: map['isTwoPopUpAdsMonthly'] != null
          ? map['isTwoPopUpAdsMonthly'] as bool
          : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopModule.fromJson(String source, String uid) =>
      ShopModule.fromMap(json.decode(source) as Map<String, dynamic>, uid);

  @override
  String toString() {
    return 'ShopModule(uid: $uid, name: $name, email: $email, phone: $phone, description: $description, image: $image, avgShippingPrice: $avgShippingPrice, avgShippingTime: $avgShippingTime, cuponText: $cuponText, cuponCode: $cuponCode, categoriesUIDs: $categoriesUIDs, subscriptions: $subscriptions, shopLink: $shopLink, keywords: $keywords, isVisible: $isVisible, userCategory: $userCategory, hits: $hits, isStaticAd: $isStaticAd, isTwoPopUpAdsMonthly: $isTwoPopUpAdsMonthly, isFourPopUpAdsMonthly: $isFourPopUpAdsMonthly, isCanSendNotification: $isCanSendNotification, validTill: $validTill)';
  }

  @override
  bool operator ==(covariant ShopModule other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.description == description &&
        other.image == image &&
        other.avgShippingPrice == avgShippingPrice &&
        other.avgShippingTime == avgShippingTime &&
        other.cuponText == cuponText &&
        other.cuponCode == cuponCode &&
        listEquals(other.categoriesUIDs, categoriesUIDs) &&
        listEquals(other.subscriptions, subscriptions) &&
        other.shopLink == shopLink &&
        listEquals(other.keywords, keywords) &&
        other.isVisible == isVisible &&
        other.userCategory == userCategory &&
        other.hits == hits &&
        other.isStaticAd == isStaticAd &&
        other.isTwoPopUpAdsMonthly == isTwoPopUpAdsMonthly &&
        other.isFourPopUpAdsMonthly == isFourPopUpAdsMonthly &&
        other.isCanSendNotification == isCanSendNotification &&
        other.validTill == validTill;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        description.hashCode ^
        image.hashCode ^
        avgShippingPrice.hashCode ^
        avgShippingTime.hashCode ^
        cuponText.hashCode ^
        cuponCode.hashCode ^
        categoriesUIDs.hashCode ^
        subscriptions.hashCode ^
        shopLink.hashCode ^
        keywords.hashCode ^
        isVisible.hashCode ^
        userCategory.hashCode ^
        hits.hashCode ^
        isStaticAd.hashCode ^
        isTwoPopUpAdsMonthly.hashCode ^
        isFourPopUpAdsMonthly.hashCode ^
        isCanSendNotification.hashCode ^
        validTill.hashCode;
  }
}
