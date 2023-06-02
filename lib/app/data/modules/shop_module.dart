// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/subscribtion_module.dart';

class ShopModule {
  String? uid;
  String name;
  String? email;
  String description;
  String image;
  double? avgShippingPrice;
  String? avgShippingTime;
  String? cuponText;
  String? cuponCode;
  List<String> categoriesUIDs = [];
  List<SubscriptionModule> subscriptions = [];
  String? shopLink;
  List<String>? keywords = [];
  bool? isVisible;
  String? userCategory;
  ShopModule({
    this.uid,
    required this.name,
    this.email,
    required this.description,
    required this.image,
    this.avgShippingPrice,
    this.avgShippingTime,
    this.cuponText,
    this.cuponCode,
    required this.categoriesUIDs,
    this.subscriptions = const [],
    this.shopLink,
    this.keywords,
    this.isVisible,
    this.userCategory,
  });

  bool get isSubscriptionExpired {
    if (subscriptions.isEmpty) return true;
    final lastSub = subscriptions.last;
    return isExpired(lastSub.from, lastSub.to);
  }

  bool isExpired(DateTime from, DateTime to) {
    final now = DateTime.now();
    return now.isBefore(from) || now.isAfter(to);
  }

  List<CategoryModule> get categories {
    final maincategories = Get.find<MainSettingsController>().mainCategories;
    final categories = maincategories
        .where((element) => categoriesUIDs.contains(element.uid))
        .toList();

    return categories;
  }

  ShopModule copyWith({
    String? uid,
    String? name,
    String? email,
    String? description,
    String? image,
    double? avgShippingPrice,
    String? avgShippingTime,
    String? cuponText,
    String? cuponCode,
    List<String>? categoriesUIDs,
    List<SubscriptionModule>? subscriptions,
    String? shopLink,
    List<String>? keywords,
    bool? isVisible,
    String? userCategory,
  }) {
    return ShopModule(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      description: description ?? this.description,
      image: image ?? this.image,
      avgShippingPrice: avgShippingPrice ?? this.avgShippingPrice,
      avgShippingTime: avgShippingTime ?? this.avgShippingTime,
      cuponText: cuponText ?? this.cuponText,
      cuponCode: cuponCode ?? this.cuponCode,
      categoriesUIDs: categoriesUIDs ?? this.categoriesUIDs,
      subscriptions: subscriptions ?? this.subscriptions,
      shopLink: shopLink ?? this.shopLink,
      keywords: keywords ?? this.keywords,
      isVisible: isVisible ?? this.isVisible,
      userCategory: userCategory ?? this.userCategory,
    );
  }

  Map<String, dynamic> toMap({bool? forSignUp}) {
    return <String, dynamic>{
      // 'uid': uid,
      'name': name,
      'email': email,
      'description': description,
      'image': image,
      'avgShippingPrice': avgShippingPrice,
      'avgShippingTime': avgShippingTime,
      'cuponText': cuponText,
      'cuponCode': cuponCode,
      'categoriesUIDs': categoriesUIDs,
      'subscriptions': (forSignUp ?? false)
          ? []
          : subscriptions.map((x) => x.toMap()).toList(),
      'shopLink': shopLink,
      'keywords': keywords,
      'isVisible': isVisible,
      if (userCategory != null) 'userCategory': userCategory,
    };
  }

  factory ShopModule.fromMap(Map<String, dynamic> map, String uid) {
    return ShopModule(
      uid: uid,
      name: map['name'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      description: map['description'] as String,
      image: map['image'] as String,
      avgShippingPrice: map['avgShippingPrice'] != null
          ? map['avgShippingPrice'] as double
          : null,
      avgShippingTime: map['avgShippingTime'] != null
          ? map['avgShippingTime'] as String
          : null,
      cuponText: map['cuponText'] != null ? map['cuponText'] as String : null,
      cuponCode: map['cuponCode'] != null ? map['cuponCode'] as String : null,
      categoriesUIDs: List<String>.from(
        (map['categoriesUIDs'] as List<dynamic>)
            .map<String>((x) => x as String),
      ),
      subscriptions: List<SubscriptionModule>.from(
        (map['subscriptions'] as List<dynamic>).map<SubscriptionModule>(
          (x) => SubscriptionModule.fromMap(x as Map<String, dynamic>),
        ),
      ),
      shopLink: map['shopLink'] != null ? map['shopLink'] as String : null,
      keywords: map['keywords'] != null
          ? List<String>.from(
              (map['keywords'] as List<dynamic>)
                  .map<String>((x) => x as String),
            )
          : [],
      isVisible: map['isVisible'] != null ? map['isVisible'] as bool : false,
      userCategory:
          map['userCategory'] != null ? map['userCategory'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopModule.fromJson(String source, String uid) =>
      ShopModule.fromMap(json.decode(source) as Map<String, dynamic>, uid);

  @override
  String toString() {
    return 'ShopModule(uid: $uid, name: $name, email: $email, description: $description, image: $image, avgShippingPrice: $avgShippingPrice, avgShippingTime: $avgShippingTime, cuponText: $cuponText, cuponCode: $cuponCode, categoriesUIDs: $categoriesUIDs, subscriptions: $subscriptions, shopLink: $shopLink, keywords: $keywords, isVisible: $isVisible, userCategory: $userCategory)';
  }

  @override
  bool operator ==(covariant ShopModule other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.description == description &&
        other.image == image &&
        other.avgShippingPrice == avgShippingPrice &&
        other.avgShippingTime == avgShippingTime &&
        other.cuponText == cuponText &&
        other.cuponCode == cuponCode &&
        listEquals(other.categoriesUIDs, categoriesUIDs) &&
        listEquals(other.subscriptions, subscriptions) &&
        other.shopLink == shopLink &&
        listEquals(other.keywords, keywords) &&
        other.isVisible == isVisible &&
        other.userCategory == userCategory;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        description.hashCode ^
        image.hashCode ^
        avgShippingPrice.hashCode ^
        avgShippingTime.hashCode ^
        cuponText.hashCode ^
        cuponCode.hashCode ^
        categoriesUIDs.hashCode ^
        subscriptions.hashCode ^
        shopLink.hashCode ^
        keywords.hashCode ^
        isVisible.hashCode ^
        userCategory.hashCode;
  }
}
