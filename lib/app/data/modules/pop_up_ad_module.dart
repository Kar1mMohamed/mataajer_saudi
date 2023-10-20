// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mataajer_saudi/app/utils/log.dart';

class PopUpAdModule {
  String? uid;
  String? title;
  String? description;
  String image;
  bool? isVisible;
  DateTime? validTill;
  String? url;
  String shopUID;
  int? hits;
  DateTime? date;
  String? cancelReason;
  PopUpAdModule({
    this.uid,
    this.title,
    this.description,
    required this.image,
    this.isVisible,
    this.validTill,
    this.url,
    required this.shopUID,
    this.hits,
    this.date,
    this.cancelReason,
  });

  void addView() async {
    try {
      await FirebaseFirestore.instance
          .collection('pop_up_ads')
          .doc(uid)
          .update(<String, dynamic>{'hits': FieldValue.increment(1)});

      log('added view to pop up ad with uid: $uid');
    } catch (e) {
      log(e);
    }
  }

  bool get isCanAcceptOrCancel => cancelReason == null && isVisible == false;

  PopUpAdModule copyWith({
    String? uid,
    String? title,
    String? description,
    String? image,
    bool? isVisible,
    DateTime? validTill,
    String? url,
    String? shopUID,
    int? hits,
    DateTime? date,
    String? cancelReason,
  }) {
    return PopUpAdModule(
      uid: uid ?? this.uid,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      isVisible: isVisible ?? this.isVisible,
      validTill: validTill ?? this.validTill,
      url: url ?? this.url,
      shopUID: shopUID ?? this.shopUID,
      hits: hits ?? this.hits,
      date: date ?? this.date,
      cancelReason: cancelReason ?? this.cancelReason,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'title': title,
      'description': description,
      'image': image,
      'isVisible': isVisible,
      'validTill': validTill != null ? Timestamp.fromDate(validTill!) : null,
      'url': url,
      'shopUID': shopUID,
      'hits': hits,
      'date': date?.millisecondsSinceEpoch,
      'cancelReason': cancelReason,
    };
  }

  factory PopUpAdModule.fromMap(Map<String, dynamic> map, {String? uid}) {
    return PopUpAdModule(
      uid: uid,
      title: map['title'] != null ? map['title'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      image: map['image'] as String,
      isVisible: map['isVisible'] != null ? map['isVisible'] as bool : null,
      validTill:
          map['validTill'] != null ? _handleTime(map['validTill']) : null,
      url: map['url'] != null ? map['url'] as String : null,
      shopUID: map['shopUID'],
      hits: map['hits'] != null ? map['hits'] as int : null,
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'] as int)
          : null,
      cancelReason:
          map['cancelReason'] != null ? map['cancelReason'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PopUpAdModule.fromJson(String source, {String? uid}) =>
      PopUpAdModule.fromMap(json.decode(source) as Map<String, dynamic>,
          uid: uid);

  @override
  String toString() {
    return 'PopUpAdModule(uid: $uid, title: $title, description: $description, image: $image, isVisible: $isVisible, validTill: $validTill, url: $url, shopUID: $shopUID, hits: $hits, date: $date, cancelReason: $cancelReason)';
  }

  @override
  bool operator ==(covariant PopUpAdModule other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.title == title &&
        other.description == description &&
        other.image == image &&
        other.isVisible == isVisible &&
        other.validTill == validTill &&
        other.url == url &&
        other.shopUID == shopUID &&
        other.hits == hits &&
        other.date == date &&
        other.cancelReason == cancelReason;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        title.hashCode ^
        description.hashCode ^
        image.hashCode ^
        isVisible.hashCode ^
        validTill.hashCode ^
        url.hashCode ^
        shopUID.hashCode ^
        hits.hashCode ^
        date.hashCode ^
        cancelReason.hashCode;
  }

  static DateTime _handleTime(dynamic date) {
    if (date is int) {
      return DateTime.fromMillisecondsSinceEpoch(date);
    } else if (date is Timestamp) {
      return date.toDate();
    } else {
      // return DateTime.now();
      throw Exception('Invalid date type');
    }
  }
}
