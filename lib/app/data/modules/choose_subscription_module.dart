// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChooseSubscriptionModule {
  final String? uid;
  String? name;
  int? allowedDays;
  double? monthlyPrice;
  double? yearlyPrice;

  ChooseSubscriptionModule({
    this.uid,
    this.name,
    this.allowedDays,
    this.monthlyPrice,
    this.yearlyPrice,
  });

  ChooseSubscriptionModule copyWith({
    String? uid,
    String? name,
    int? allowedDays,
    double? monthlyPrice,
    double? yearlyPrice,
  }) {
    return ChooseSubscriptionModule(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      allowedDays: allowedDays ?? this.allowedDays,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      yearlyPrice: yearlyPrice ?? this.yearlyPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'uid': uid,
      if (name != null) 'name': name,
      if (allowedDays != null) 'allowedDays': allowedDays,
      if (monthlyPrice != null) 'monthlyPrice': monthlyPrice,
      if (yearlyPrice != null) 'yearlyPrice': yearlyPrice,
    };
  }

  factory ChooseSubscriptionModule.fromMap(Map<String, dynamic> map,
      {String? uid}) {
    return ChooseSubscriptionModule(
      uid: uid,
      name: map['name'] != null ? map['name'] as String : null,
      allowedDays:
          map['allowedDays'] != null ? map['allowedDays'] as int : null,
      monthlyPrice:
          map['monthlyPrice'] != null ? map['monthlyPrice'] as double : null,
      yearlyPrice:
          map['yearlyPrice'] != null ? map['yearlyPrice'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChooseSubscriptionModule.fromJson(String source) =>
      ChooseSubscriptionModule.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChooseSubscriptionModule(uid: $uid, name: $name, allowedDays: $allowedDays, monthlyPrice: $monthlyPrice, yearlyPrice: $yearlyPrice)';
  }

  @override
  bool operator ==(covariant ChooseSubscriptionModule other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.allowedDays == allowedDays &&
        other.monthlyPrice == monthlyPrice &&
        other.yearlyPrice == yearlyPrice;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        allowedDays.hashCode ^
        monthlyPrice.hashCode ^
        yearlyPrice.hashCode;
  }
}
