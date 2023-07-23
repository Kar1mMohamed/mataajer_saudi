// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'package:mataajer_saudi/app/data/constants.dart';

part 'notification.g.dart';

@HiveType(typeId: 2)
class NotificationModule extends HiveObject {
  static const String boxName = 'notifications';
  static Future<Box<NotificationModule>> openBox =
      Hive.openBox<NotificationModule>(boxName);

  static Box<NotificationModule> hiveBox =
      Hive.box<NotificationModule>(boxName);

  static List<NotificationModule> get notifications {
    var notifications = hiveBox.values;

    _readAllNotifications();

    return notifications.toList();
  }

  static void _readAllNotifications() async {
    for (var element in hiveBox.values) {
      element.isRead = true;
      await element.save();
    }
  }

  @HiveField(0)
  int? index;
  @HiveField(1)
  String? token;
  @HiveField(2)
  String? title;
  @HiveField(3)
  String? body;
  Map<String, dynamic>? data;
  @HiveField(4)
  DateTime? date;
  @HiveField(5)

  /// equal null if the notification is not read
  bool? isRead;
  @HiveField(6)
  bool? isActive;
  @HiveField(7)
  String? senderUserUID;

  @HiveField(8)
  String? senderUserImage;

  String? docUID;

  /// this variable used when admin send notification to users to count the number of users that received the notification
  String sendingText = '';

  String? cancelReason;

  static RxInt get notCount => hiveBox.values
      .where((element) => element.isRead == null || element.isRead == false)
      .length
      .obs;

  String? get timeString =>
      date != null ? Constants.convertDateToTimeString(date!) : null;

  String get formateDate =>
      date != null ? (Constants.convertDateToDateString(date!) ?? '') : '';

  bool get isCanAcceptOrCancel =>
      cancelReason == null && (isActive ?? false) == false;

  NotificationModule({
    this.index,
    this.token,
    this.title,
    this.body,
    this.data,
    required this.date,
    this.isRead,
    this.isActive,
    this.senderUserUID,
    this.senderUserImage,
    this.docUID,
    this.cancelReason,
  });

  NotificationModule copyWith({
    int? index,
    String? token,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    DateTime? date,
    bool? isRead,
    bool? isActive,
    String? senderUserUID,
    String? docUID,
    String? cancelReason,
  }) {
    return NotificationModule(
      index: index ?? this.index,
      token: token ?? this.token,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      date: date ?? this.date,
      isRead: isRead ?? this.isRead,
      isActive: isActive ?? this.isActive,
      senderUserUID: senderUserUID ?? this.senderUserUID,
      docUID: docUID ?? this.docUID,
      cancelReason: cancelReason ?? this.cancelReason,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'index': index,
      'token': token,
      'title': title,
      'body': body,
      'data': data,
      'date': date?.millisecondsSinceEpoch,
      'isRead': isRead,
      'isActive': isActive,
      'senderUserUID': senderUserUID,
      if (docUID != null) 'docUID': docUID,
      if (cancelReason != null) 'cancelReason': cancelReason,
    };
  }

  factory NotificationModule.fromMap(Map<String, dynamic> map,
      {String? docUID}) {
    return NotificationModule(
      index: map['index'] != null ? map['index'] as int : null,
      token: map['token'] != null ? map['token'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      body: map['body'] != null ? map['body'] as String : null,
      data: map['data'] != null
          ? Map<String, dynamic>.from((map['data'] as Map<String, dynamic>))
          : null,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      isRead: map['isRead'] != null ? map['isRead'] as bool : null,
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
      senderUserUID:
          map['senderUserUID'] != null ? map['senderUserUID'] as String : null,
      docUID:
          docUID ?? (map['docUID'] != null ? map['docUID'] as String : null),
      cancelReason:
          map['cancelReason'] != null ? map['cancelReason'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModule.fromJson(String source) =>
      NotificationModule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationModule(index: $index, token: $token, title: $title, body: $body, data: $data, date: $date, isRead: $isRead, isActive: $isActive, senderUserUID: $senderUserUID, docUID: $docUID, cancelReason: $cancelReason)';
  }

  @override
  bool operator ==(covariant NotificationModule other) {
    if (identical(this, other)) return true;

    return other.index == index &&
        other.token == token &&
        other.title == title &&
        other.body == body &&
        mapEquals(other.data, data) &&
        other.date == date &&
        other.isRead == isRead &&
        other.isActive == isActive &&
        other.senderUserUID == senderUserUID &&
        other.docUID == docUID &&
        other.cancelReason == cancelReason;
  }

  @override
  int get hashCode {
    return index.hashCode ^
        token.hashCode ^
        title.hashCode ^
        body.hashCode ^
        data.hashCode ^
        date.hashCode ^
        isRead.hashCode ^
        isActive.hashCode ^
        senderUserUID.hashCode ^
        docUID.hashCode ^
        cancelReason.hashCode;
  }
}
