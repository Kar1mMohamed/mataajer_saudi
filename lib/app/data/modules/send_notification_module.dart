// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SendNotifictaionModule {
  String token;
  String title;
  String body;
  Map<String, dynamic>? data;
  String? userUID;
  String? userSenderImage;
  SendNotifictaionModule({
    required this.token,
    required this.title,
    required this.body,
    this.data,
    this.userUID,
    this.userSenderImage,
  });

  SendNotifictaionModule copyWith({
    String? token,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    String? userUID,
    String? userSenderImage,
  }) {
    return SendNotifictaionModule(
      token: token ?? this.token,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      userUID: userUID ?? this.userUID,
      userSenderImage: userSenderImage ?? this.userSenderImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'title': title,
      'body': body,
      'data': data,
      'userUID': userUID,
      'userSenderImage': userSenderImage,
    };
  }

  Map<String, dynamic> requestToMap() {
    final data = <String, dynamic>{
      if (userSenderImage != null) 'url': userSenderImage,
      if (userUID != null) 'userUID': userUID,
    }..addAll(this.data ?? {});
    return <String, dynamic>{
      'to': token,
      'notification': {
        'title': title,
        'body': body,
      },
      'data': data,
    };
  }

  factory SendNotifictaionModule.fromMap(Map<String, dynamic> map) {
    return SendNotifictaionModule(
      token: map['token'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      data: map['data'] != null
          ? Map<String, dynamic>.from((map['data'] as Map<String, dynamic>))
          : null,
      userUID: map['userUID'] != null ? map['userUID'] as String : null,
      userSenderImage: map['userSenderImage'] != null
          ? map['userSenderImage'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SendNotifictaionModule.fromJson(String source) =>
      SendNotifictaionModule.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SendNotifictaionModule(token: $token, title: $title, body: $body, data: $data, userUID: $userUID, userSenderImage: $userSenderImage)';
  }

  @override
  bool operator ==(covariant SendNotifictaionModule other) {
    if (identical(this, other)) return true;

    return other.token == token &&
        other.title == title &&
        other.body == body &&
        mapEquals(other.data, data) &&
        other.userUID == userUID &&
        other.userSenderImage == userSenderImage;
  }

  @override
  int get hashCode {
    return token.hashCode ^
        title.hashCode ^
        body.hashCode ^
        data.hashCode ^
        userUID.hashCode ^
        userSenderImage.hashCode;
  }
}
