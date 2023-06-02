// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
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

  List<CategoryModule> get categories => Get.find<MainSettingsController>()
      .mainCategories
      .where((e) => categoryUIDs.contains(e.uid))
      .toList();

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
      'validTill': validTill,
    };
  }

  factory AdModule.fromMap(Map<String, dynamic> map) {
    return AdModule(
      uid: map['uid'] != null ? map['uid'] as String : null,
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
          ? DateTime.parse(map['validTill'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AdModule.fromJson(String source) =>
      AdModule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AdModule(uid: $uid, shopUID: $shopUID, name: $name, categoryUIDs: $categoryUIDs, description: $description, avgShippingPrice: $avgShippingPrice, avgShippingTime: $avgShippingTime, cuponCode: $cuponCode, imageURL: $imageURL, hits: $hits, validTill: $validTill)';
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
        other.validTill == validTill;
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
        validTill.hashCode;
  }
}
