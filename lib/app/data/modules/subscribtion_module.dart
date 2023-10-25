// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionModule {
  final String? uid;
  final DateTime from;
  final DateTime to;
  final String? subscriptionSettingUID;
  SubscriptionModule({
    this.uid,
    required this.from,
    required this.to,
    this.subscriptionSettingUID,
  });

  SubscriptionModule copyWith({
    String? uid,
    DateTime? from,
    DateTime? to,
    String? subscriptionSettingUID,
  }) {
    return SubscriptionModule(
      uid: uid ?? this.uid,
      from: from ?? this.from,
      to: to ?? this.to,
      subscriptionSettingUID:
          subscriptionSettingUID ?? this.subscriptionSettingUID,
    );
  }

  Map<String, dynamic> toMap(
      {bool postUID = false, bool transferTimeStampIntoDate = true}) {
    return <String, dynamic>{
      if (uid != null || postUID) 'uid': uid,
      'from': transferTimeStampIntoDate
          ? from.millisecondsSinceEpoch
          : Timestamp.fromDate(from),
      'to': transferTimeStampIntoDate
          ? to.millisecondsSinceEpoch
          : Timestamp.fromDate(to),
      'subscriptionSettingUID': subscriptionSettingUID,
    };
  }

  factory SubscriptionModule.fromMap(Map<String, dynamic> map, {String? uid}) {
    return SubscriptionModule(
      uid: uid ?? (map['uid'] != null ? map['uid'] as String : null),
      from: _handleDateTime(map['from'])!,
      to: _handleDateTime(map['to'])!,
      subscriptionSettingUID: map['subscriptionSettingUID'] != null
          ? map['subscriptionSettingUID'] as String
          : null,
    );
  }

  static DateTime? _handleDateTime(dynamic dateTime) {
    try {
      if (dateTime is Timestamp) {
        return dateTime.toDate();
      } else if (dateTime is int) {
        try {
          return DateTime.fromMillisecondsSinceEpoch(dateTime);
        } catch (e) {
          print(e);
          return DateTime.fromMicrosecondsSinceEpoch(dateTime);
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // String toJson() => json.encode(toMap(transferTimeStampIntoDate: true));

  factory SubscriptionModule.fromJson(String source) =>
      SubscriptionModule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubscriptionModule(uid: $uid, from: $from, to: $to, subscriptionSettingUID: $subscriptionSettingUID)';
  }

  @override
  bool operator ==(covariant SubscriptionModule other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.from == from &&
        other.to == to &&
        other.subscriptionSettingUID == subscriptionSettingUID;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        from.hashCode ^
        to.hashCode ^
        subscriptionSettingUID.hashCode;
  }
}
