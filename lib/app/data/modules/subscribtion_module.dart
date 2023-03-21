// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SubscribtionModule {
  final String uid;
  final DateTime from;
  final DateTime to;
  SubscribtionModule({
    required this.uid,
    required this.from,
    required this.to,
  });

  SubscribtionModule copyWith({
    String? uid,
    DateTime? from,
    DateTime? to,
  }) {
    return SubscribtionModule(
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

  factory SubscribtionModule.fromMap(Map<String, dynamic> map) {
    return SubscribtionModule(
      uid: map['uid'] as String,
      from: DateTime.fromMillisecondsSinceEpoch(map['from'] as int),
      to: DateTime.fromMillisecondsSinceEpoch(map['to'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscribtionModule.fromJson(String source) =>
      SubscribtionModule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SubscribtionModule(uid: $uid, from: $from, to: $to)';

  @override
  bool operator ==(covariant SubscribtionModule other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.from == from && other.to == to;
  }

  @override
  int get hashCode => uid.hashCode ^ from.hashCode ^ to.hashCode;
}
