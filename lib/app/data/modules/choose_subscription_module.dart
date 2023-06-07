// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChooseSubscriptionModule {
  final String? uid;
  String? name;
  int? allowedDays = 365; // default
  double? monthlyPrice;
  double? yearlyPrice;
  bool? isPublishable = true;
  bool? isStatic = false;
  bool? isTwoPopUpAdsMonthly = false;
  bool? isFourPopUpAdsMonthly = false;
  bool? isCanSendNotification = false;

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
    this.isCanSendNotification,
  });

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
    bool? isCanSendNotification,
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
      isCanSendNotification:
          isCanSendNotification ?? this.isCanSendNotification,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'allowedDays': allowedDays,
      'monthlyPrice': monthlyPrice,
      'yearlyPrice': yearlyPrice,
      'isPublishable': isPublishable,
      'isStatic': isStatic,
      'isTwoPopUpAdsMonthly': isTwoPopUpAdsMonthly,
      'isFourPopUpAdsMonthly': isFourPopUpAdsMonthly,
      'isCanSendNotification': isCanSendNotification,
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
      isCanSendNotification: map['isCanSendNotification'] != null
          ? map['isCanSendNotification'] as bool
          : null,
    );
  }
  String toJson() => json.encode(toMap());

  factory ChooseSubscriptionModule.fromJson(String source) =>
      ChooseSubscriptionModule.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChooseSubscriptionModule(uid: $uid, name: $name, allowedDays: $allowedDays, monthlyPrice: $monthlyPrice, yearlyPrice: $yearlyPrice, isPublishable: $isPublishable, isStatic: $isStatic, isTwoPopUpAdsMonthly: $isTwoPopUpAdsMonthly, isFourPopUpAdsMonthly: $isFourPopUpAdsMonthly, isCanSendNotification: $isCanSendNotification)';
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
        other.isCanSendNotification == isCanSendNotification;
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
        isCanSendNotification.hashCode;
  }
}