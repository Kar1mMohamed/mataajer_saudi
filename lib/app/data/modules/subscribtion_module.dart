// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SubscriptionModule {
  final String? uid;
  final DateTime from;
  final DateTime to;
  SubscriptionModule({
    this.uid,
    required this.from,
    required this.to,
  });

  SubscriptionModule copyWith({
    String? uid,
    DateTime? from,
    DateTime? to,
  }) {
    return SubscriptionModule(
      uid: uid ?? this.uid,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'from': from.millisecondsSinceEpoch,
      'to': to.millisecondsSinceEpoch,
    };
  }

  factory SubscriptionModule.fromMap(Map<String, dynamic> map) {
    return SubscriptionModule(
      uid: map['uid'] != null ? map['uid'] as String : null,
      from: DateTime.fromMillisecondsSinceEpoch(map['from'] as int),
      to: DateTime.fromMillisecondsSinceEpoch(map['to'] as int),
    );
  }

  String toJson() => json.encode(toMap());

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
