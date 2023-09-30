// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChooseSubscriptionModule {
  String? uid;
  String? name;
  int? allowedDays = 365; // default
  double? monthlyPrice;
  double? yearlyPrice;
  bool? isPublishable = true;
  bool? isStatic = false;
  bool? isTwoPopUpAdsMonthly = false;
  bool? isFourPopUpAdsMonthly = false;
  bool? isCanSendTwoNotification = false;
  bool? isCanSendFourNotification = false;

  DateTime? subscriptionDate = DateTime.now();

  double? get getPriceByDays => allowedDays == 30 ? monthlyPrice : yearlyPrice;

  ChooseSubscriptionModule({
    this.uid,
    this.name,
    this.allowedDays = 365, // default
    this.monthlyPrice,
    this.yearlyPrice,
    this.isPublishable,
    this.isStatic,
    this.isTwoPopUpAdsMonthly,
    this.isFourPopUpAdsMonthly,
    this.isCanSendTwoNotification,
    this.isCanSendFourNotification,
    this.subscriptionDate,
  }) {
    uid ??= name;
  }

  ChooseSubscriptionModule copyWith({
    String? uid,
    String? name,
    int? allowedDays,
    double? monthlyPrice,
    double? yearlyPrice,
    bool? isPublishable,
    bool? isStatic,
    bool? isTwoPopUpAdsMonthly,
    bool? isFourPopUpAdsMonthly,
    bool? isCanSendTwoNotification,
    bool? isCanSendFourNotification,
  }) {
    return ChooseSubscriptionModule(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      allowedDays: allowedDays ?? this.allowedDays,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      yearlyPrice: yearlyPrice ?? this.yearlyPrice,
      isPublishable: isPublishable ?? this.isPublishable,
      isStatic: isStatic ?? this.isStatic,
      isTwoPopUpAdsMonthly: isTwoPopUpAdsMonthly ?? this.isTwoPopUpAdsMonthly,
      isFourPopUpAdsMonthly:
          isFourPopUpAdsMonthly ?? this.isFourPopUpAdsMonthly,
      isCanSendTwoNotification:
          isCanSendTwoNotification ?? this.isCanSendTwoNotification,
      isCanSendFourNotification:
          isCanSendFourNotification ?? this.isCanSendFourNotification,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'uid': uid,
      'name': name,
      'allowedDays': allowedDays,
      'monthlyPrice': monthlyPrice,
      'yearlyPrice': yearlyPrice,
      'isPublishable': isPublishable,
      'isStatic': isStatic,
      'isTwoPopUpAdsMonthly': isTwoPopUpAdsMonthly,
      'isFourPopUpAdsMonthly': isFourPopUpAdsMonthly,
      'isCanSendTwoNotification': isCanSendTwoNotification,
      'isCanSendFourNotification': isCanSendFourNotification,
      // 'subscriptionDate': subscriptionDate,
    };
  }

  factory ChooseSubscriptionModule.fromMap(Map<String, dynamic> map,
      {String? uid}) {
    return ChooseSubscriptionModule(
      uid: uid ?? map['uid'] as String?,
      name: map['name'] != null ? map['name'] as String : null,
      allowedDays:
          map['allowedDays'] != null ? map['allowedDays'] as int : null,
      monthlyPrice:
          map['monthlyPrice'] != null ? map['monthlyPrice'] as double : null,
      yearlyPrice: map['yearlyPrice'] != null
          ? (map['yearlyPrice'] as num).toDouble()
          : null,
      isPublishable:
          map['isPublishable'] != null ? map['isPublishable'] as bool : null,
      isStatic: map['isStatic'] != null ? map['isStatic'] as bool : null,
      isTwoPopUpAdsMonthly: map['isTwoPopUpAdsMonthly'] != null
          ? map['isTwoPopUpAdsMonthly'] as bool
          : null,
      isFourPopUpAdsMonthly: map['isFourPopUpAdsMonthly'] != null
          ? map['isFourPopUpAdsMonthly'] as bool
          : null,
      isCanSendTwoNotification: map['isCanSendTwoNotification'] != null
          ? map['isCanSendTwoNotification'] as bool
          : null,
      isCanSendFourNotification: map['isCanSendFourNotification'] != null
          ? map['isCanSendFourNotification'] as bool
          : null,
      subscriptionDate: map['subscriptionDate'] != null
          ? (map['subscriptionDate'] as Timestamp).toDate()
          : null,
    );
  }
  String toJson() => json.encode(toMap());

  factory ChooseSubscriptionModule.fromJson(String source) =>
      ChooseSubscriptionModule.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChooseSubscriptionModule(uid: $uid, name: $name, allowedDays: $allowedDays, monthlyPrice: $monthlyPrice, yearlyPrice: $yearlyPrice, isPublishable: $isPublishable, isStatic: $isStatic, isTwoPopUpAdsMonthly: $isTwoPopUpAdsMonthly, isFourPopUpAdsMonthly: $isFourPopUpAdsMonthly, isCanSendTwoNotification: $isCanSendTwoNotification, isCanSendFourNotification: $isCanSendFourNotification,subscriptionDate: $subscriptionDate)';
  }

  @override
  bool operator ==(covariant ChooseSubscriptionModule other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.allowedDays == allowedDays &&
        other.monthlyPrice == monthlyPrice &&
        other.yearlyPrice == yearlyPrice &&
        other.isPublishable == isPublishable &&
        other.isStatic == isStatic &&
        other.isTwoPopUpAdsMonthly == isTwoPopUpAdsMonthly &&
        other.isFourPopUpAdsMonthly == isFourPopUpAdsMonthly &&
        other.isCanSendTwoNotification == isCanSendTwoNotification &&
        other.isCanSendFourNotification == isCanSendFourNotification &&
        other.subscriptionDate == subscriptionDate;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        allowedDays.hashCode ^
        monthlyPrice.hashCode ^
        yearlyPrice.hashCode ^
        isPublishable.hashCode ^
        isStatic.hashCode ^
        isTwoPopUpAdsMonthly.hashCode ^
        isFourPopUpAdsMonthly.hashCode ^
        isCanSendTwoNotification.hashCode ^
        isCanSendFourNotification.hashCode ^
        subscriptionDate.hashCode;
  }
}
