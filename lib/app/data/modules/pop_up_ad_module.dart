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
      validTill: map['validTill'] != null
          ? (map['validTill'] as Timestamp).toDate()
          : null,
      url: map['url'] != null ? map['url'] as String : null,
      shopUID: map['shopUID'],
      hits: map['hits'] != null ? map['hits'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PopUpAdModule.fromJson(String source, {String? uid}) =>
      PopUpAdModule.fromMap(json.decode(source) as Map<String, dynamic>,
          uid: uid);

  @override
  String toString() {
    return 'PopUpAdModule(uid: $uid, title: $title, description: $description, image: $image, isVisible: $isVisible, validTill: $validTill, url: $url, shopUID: $shopUID, hits: $hits)';
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
        other.hits == hits;
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
        hits.hashCode;
  }
}
