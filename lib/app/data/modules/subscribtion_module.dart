// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionModule {
  final String? uid;
  final DateTime from;
  final DateTime to;
  final String subscriptionUID;
  SubscriptionModule({
    this.uid,
    required this.from,
    required this.to,
    required this.subscriptionUID,
  });

  SubscriptionModule copyWith({
    String? uid,
    DateTime? from,
    DateTime? to,
    String? subscriptionUID,
  }) {
    return SubscriptionModule(
        uid: uid ?? this.uid,
        from: from ?? this.from,
        to: to ?? this.to,
        subscriptionUID: subscriptionUID ?? this.subscriptionUID);
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
      'subscriptionUID': subscriptionUID,
    };
  }

  factory SubscriptionModule.fromMap(Map<String, dynamic> map) {
    return SubscriptionModule(
      uid: map['uid'] != null ? map['uid'] as String : null,
      from: (map['from'] as Timestamp).toDate(),
      to: (map['to'] as Timestamp).toDate(),
      subscriptionUID: map['subscriptionUID'] as String,
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
