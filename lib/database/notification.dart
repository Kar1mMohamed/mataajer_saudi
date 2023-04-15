// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'notification.g.dart';

@HiveType(typeId: 1)
class LocalNotificationHive {
  static const String boxName = 'notifications';
  static Future<Box<LocalNotificationHive>> openBox =
      Hive.openBox<LocalNotificationHive>(boxName);
  static Box<LocalNotificationHive> box =
      Hive.box<LocalNotificationHive>(boxName);

  @HiveField(0)
  int? index;
  @HiveField(1)
  String? token;
  @HiveField(2)
  String? title;
  @HiveField(3)
  String? body;
  Map<String, dynamic>? data;
  LocalNotificationHive({
    this.index,
    this.token,
    this.title,
    this.body,
    this.data,
  });

  LocalNotificationHive copyWith({
    int? index,
    String? token,
    String? title,
    String? body,
    Map<String, dynamic>? data,
  }) {
    return LocalNotificationHive(
      index: index ?? this.index,
      token: token ?? this.token,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'index': index,
      'token': token,
      'title': title,
      'body': body,
      'data': data,
    };
  }

  factory LocalNotificationHive.fromMap(Map<String, dynamic> map) {
    return LocalNotificationHive(
      index: map['index'] != null ? map['index'] as int : null,
      token: map['token'] != null ? map['token'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      body: map['body'] != null ? map['body'] as String : null,
      data: map['data'] != null
          ? Map<String, dynamic>.from((map['data'] as Map<String, dynamic>))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LocalNotificationHive.fromJson(String source) =>
      LocalNotificationHive.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LocalNotificationHive(index: $index, token: $token, title: $title, body: $body, data: $data)';
  }

  @override
  bool operator ==(covariant LocalNotificationHive other) {
    if (identical(this, other)) return true;

    return other.index == index &&
        other.token == token &&
        other.title == title &&
        other.body == body &&
        mapEquals(other.data, data);
  }

  @override
  int get hashCode {
    return index.hashCode ^
        token.hashCode ^
        title.hashCode ^
        body.hashCode ^
        data.hashCode;
  }
}
