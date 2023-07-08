// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';

class AdModule {
  final String? uid;
  final String? shopUID;
  final String name;
  final List<String> categoryUIDs;
  final String description;
  final double? avgShippingPrice;
  final String? avgShippingTime;
  final String? cuponCode;
  final String imageURL;
  int? hits;
  DateTime? validTill;
  bool? isStaticAd;
  bool? isVisible;

  bool get isMostVisitAd {
    return true; // Temprory true untill do it as logic
  }

  bool get isMostOffers {
    return true; // Temprory true untill do it as logic
  }

  bool get isOtherAd {
    if ((isStaticAd ?? false) || isMostOffers || isMostOffers) {
      return false;
    } else {
      return true;
    }
  }

  List<CategoryModule> get categories => Get.find<MainSettingsController>()
      .mainCategories
      .where((e) => categoryUIDs.contains(e.uid))
      .toList();

  bool get isValidAdDate {
    if (validTill == null) {
      return false;
    }

    return validTill!.isAfter(DateTime.now());
  }

  AdModule({
    this.uid,
    this.shopUID,
    required this.name,
    required this.categoryUIDs,
    required this.description,
    this.avgShippingPrice,
    this.avgShippingTime,
    this.cuponCode,
    required this.imageURL,
    this.hits,
    this.validTill,
    this.isStaticAd,
    this.isVisible,
  });

  AdModule copyWith({
    String? uid,
    String? shopUID,
    String? name,
    List<String>? categoryUIDs,
    String? description,
    double? avgShippingPrice,
    String? avgShippingTime,
    String? cuponCode,
    String? imageURL,
    int? hits,
    DateTime? validTill,
    bool? isStaticAd,
    bool? isVisible,
  }) {
    return AdModule(
      uid: uid ?? this.uid,
      shopUID: shopUID ?? this.shopUID,
      name: name ?? this.name,
      categoryUIDs: categoryUIDs ?? this.categoryUIDs,
      description: description ?? this.description,
      avgShippingPrice: avgShippingPrice ?? this.avgShippingPrice,
      avgShippingTime: avgShippingTime ?? this.avgShippingTime,
      cuponCode: cuponCode ?? this.cuponCode,
      imageURL: imageURL ?? this.imageURL,
      hits: hits ?? this.hits,
      validTill: validTill ?? this.validTill,
      isStaticAd: isStaticAd ?? this.isStaticAd,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'uid': uid,
      'shopUID': shopUID,
      'name': name,
      'categoryUIDs': categoryUIDs,
      'description': description,
      'avgShippingPrice': avgShippingPrice,
      'avgShippingTime': avgShippingTime,
      'cuponCode': cuponCode,
      'imageURL': imageURL,
      'hits': hits,
      if (validTill != null) 'validTill': Timestamp.fromDate(validTill!),
      'isStaticAd': isStaticAd,
      'isVisible': isVisible,
    };
  }

  factory AdModule.fromMap(Map<String, dynamic> map, {String? uid}) {
    return AdModule(
      uid: uid,
      shopUID: map['shopUID'] != null ? map['shopUID'] as String : null,
      name: map['name'] as String,
      categoryUIDs: List<String>.from((map['categoryUIDs'] as List<dynamic>)),
      description: map['description'] as String,
      avgShippingPrice: map['avgShippingPrice'] != null
          ? map['avgShippingPrice'] as double
          : null,
      avgShippingTime: map['avgShippingTime'] != null
          ? map['avgShippingTime'] as String
          : null,
      cuponCode: map['cuponCode'] != null ? map['cuponCode'] as String : null,
      imageURL: map['imageURL'] as String,
      hits: map['hits'] != null ? map['hits'] as int : null,
      validTill: map['validTill'] != null
          ? (map['validTill'] as Timestamp).toDate()
          : null,
      isStaticAd: map['isStaticAd'] != null ? map['isStaticAd'] as bool : null,
      isVisible: map['isVisible'] != null ? map['isVisible'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdModule.fromJson(String source) =>
      AdModule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AdModule(uid: $uid, shopUID: $shopUID, name: $name, categoryUIDs: $categoryUIDs, description: $description, avgShippingPrice: $avgShippingPrice, avgShippingTime: $avgShippingTime, cuponCode: $cuponCode, imageURL: $imageURL, hits: $hits, validTill: $validTill, isStaticAd: $isStaticAd, isVisible: $isVisible)';
  }

  @override
  bool operator ==(covariant AdModule other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.shopUID == shopUID &&
        other.name == name &&
        listEquals(other.categoryUIDs, categoryUIDs) &&
        other.description == description &&
        other.avgShippingPrice == avgShippingPrice &&
        other.avgShippingTime == avgShippingTime &&
        other.cuponCode == cuponCode &&
        other.imageURL == imageURL &&
        other.hits == hits &&
        other.validTill == validTill &&
        other.isStaticAd == isStaticAd &&
        other.isVisible == isVisible;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        shopUID.hashCode ^
        name.hashCode ^
        categoryUIDs.hashCode ^
        description.hashCode ^
        avgShippingPrice.hashCode ^
        avgShippingTime.hashCode ^
        cuponCode.hashCode ^
        imageURL.hashCode ^
        hits.hashCode ^
        validTill.hashCode ^
        isStaticAd.hashCode ^
        isVisible.hashCode;
  }
}
