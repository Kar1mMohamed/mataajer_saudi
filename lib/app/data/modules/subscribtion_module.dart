// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionModule {
  final String? uid;
  final DateTime from;
  final DateTime to;
  final String subscriptionSettingUID;
  SubscriptionModule({
    this.uid,
    required this.from,
    required this.to,
    required this.subscriptionSettingUID,
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
            subscriptionSettingUID ?? this.subscriptionSettingUID);
  }

  Map<String, dynamic> toMap(
      {bool postUID = false, bool transferTimeStampIntoDate = false}) {
    return <String, dynamic>{
      if (uid != null || postUID) 'uid': uid,
      'from': transferTimeStampIntoDate
          ? from.millisecondsSinceEpoch
          : Timestamp.fromDate(from),
      'to': transferTimeStampIntoDate
          ? to.microsecondsSinceEpoch
          : Timestamp.fromDate(to),
      'subscriptionSettingUID': subscriptionSettingUID,
    };
  }

  factory SubscriptionModule.fromMap(Map<String, dynamic> map) {
    return SubscriptionModule(
      uid: map['uid'] != null ? map['uid'] as String : null,
      from: (map['from'] as Timestamp).toDate(),
      to: (map['to'] as Timestamp).toDate(),
      subscriptionSettingUID: map['subscriptionSettingUID'] as String,
    );
  }

  String toJson() => json.encode(toMap(transferTimeStampIntoDate: true));

  factory SubscriptionModule.fromJson(String source) =>
      SubscriptionModule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SubscriptionModule(uid: $uid, from: $from, to: $to)';

  @override
  bool operator ==(covariant SubscriptionModule other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.from == from && other.to == to;
  }

  @override
  int get hashCode => uid.hashCode ^ from.hashCode ^ to.hashCode;
}
