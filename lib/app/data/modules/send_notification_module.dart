// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SendNotifictaionModule {
  String token;
  String title;
  String body;
  Map<String, dynamic>? data;
  SendNotifictaionModule({
    required this.token,
    required this.title,
    required this.body,
    this.data,
  });

  SendNotifictaionModule copyWith({
    String? token,
    String? title,
    String? body,
    Map<String, dynamic>? data,
  }) {
    return SendNotifictaionModule(
      token: token ?? this.token,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "to": token,
      "notification": {"title": title, "body": body},
      "data": data,
    };
  }

  factory SendNotifictaionModule.fromMap(Map<String, dynamic> map) {
    return SendNotifictaionModule(
      token: map['to'] as String,
      title: map['notification']['title'] as String,
      body: map['notification']['body'] as String,
      data: map['data'] != null
          ? Map<String, dynamic>.from((map['data'] as Map<String, dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SendNotifictaionModule.fromJson(String source) =>
      SendNotifictaionModule.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SendNotifictaionModule(token: $token, title: $title, body: $body, data: $data)';
  }

  @override
  bool operator ==(covariant SendNotifictaionModule other) {
    if (identical(this, other)) return true;

    return other.token == token &&
        other.title == title &&
        other.body == body &&
        mapEquals(other.data, data);
  }

  @override
  int get hashCode {
    return token.hashCode ^ title.hashCode ^ body.hashCode ^ data.hashCode;
  }
}
