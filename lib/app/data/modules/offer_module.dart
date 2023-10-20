// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:mataajer_saudi/app/controllers/main_settings_controller.dart';
import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/utils/log.dart';

class OfferModule {
  final String? uid;
  final String? shopUID;
  final String name;
  final String? shopDescription;
  final String? offerDescription;
  final String? offerPercentageDescription;
  List<String> categoryUIDs;
  final DateTime? fromDate;
  final DateTime? toDate;
  final double? avgShippingPrice;
  final String? avgShippingTime;
  final double? offerPercentage;
  final String imageURL;
  int? hits;
  DateTime? validTill;
  bool? isStaticAd;
  bool? isVisible;
  String? offerLink;
  double? priceBefore;
  double? priceAfter;

  /// (+1): if = 1 that mean that this valid to 'this' day
  int get remainingDays {
    if (toDate == null) return 0;
    var remainingDays = toDate!.difference(DateTime.now()).inDays;
    log('remainingDays: $remainingDays, toDate: $toDate');

    return remainingDays + 1;
  }

  // bool get isMostVisitedOffer {
  //   try {
  //     final offers = Get.find<HomeController>().offers;

  //     int averageHits = offers.fold<int>(
  //             0, (previousValue, element) => previousValue + element.hits!) ~/
  //         offers.length;

  //     if (hits! > averageHits) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     log('isMostVisitAd: $e');
  //     return false;
  //   }
  // }

  // bool get isMostOffers {
  //   return true; // Temprory true untill do it as logic
  // }

  // bool get isOtherAd {
  //   if ((isStaticAd ?? false) || isMostOffers || isMostOffers) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

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

  OfferModule({
    this.uid,
    this.shopUID,
    required this.name,
    this.shopDescription,
    this.offerDescription,
    this.offerPercentageDescription,
    required this.categoryUIDs,
    this.fromDate,
    this.toDate,
    this.avgShippingPrice,
    this.avgShippingTime,
    this.offerPercentage,
    required this.imageURL,
    this.hits,
    this.validTill,
    this.isStaticAd,
    this.isVisible,
    this.offerLink,
    this.priceBefore,
    this.priceAfter,
  });

  OfferModule copyWith({
    String? uid,
    String? shopUID,
    String? name,
    String? shopDescription,
    String? offerDescription,
    String? offerPercentageDescription,
    List<String>? categoryUIDs,
    DateTime? fromDate,
    DateTime? toDate,
    double? avgShippingPrice,
    String? avgShippingTime,
    double? offerPercentage,
    String? imageURL,
    int? hits,
    DateTime? validTill,
    bool? isStaticAd,
    bool? isVisible,
    String? offerLink,
    double? priceBefore,
    double? priceAfter,
  }) {
    return OfferModule(
      uid: uid ?? this.uid,
      shopUID: shopUID ?? this.shopUID,
      name: name ?? this.name,
      shopDescription: shopDescription ?? this.shopDescription,
      offerDescription: offerDescription ?? this.offerDescription,
      offerPercentageDescription:
          offerPercentageDescription ?? this.offerPercentageDescription,
      categoryUIDs: categoryUIDs ?? this.categoryUIDs,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      avgShippingPrice: avgShippingPrice ?? this.avgShippingPrice,
      avgShippingTime: avgShippingTime ?? this.avgShippingTime,
      offerPercentage: offerPercentage ?? this.offerPercentage,
      imageURL: imageURL ?? this.imageURL,
      hits: hits ?? this.hits,
      validTill: validTill ?? this.validTill,
      isStaticAd: isStaticAd ?? this.isStaticAd,
      isVisible: isVisible ?? this.isVisible,
      offerLink: offerLink ?? this.offerLink,
      priceBefore: priceBefore ?? this.priceBefore,
      priceAfter: priceAfter ?? this.priceAfter,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'shopUID': shopUID,
      'name': name,
      'shopDescription': shopDescription,
      'offerDescription': offerDescription,
      'offerPercentageDescription': offerPercentageDescription,
      'categoryUIDs': categoryUIDs,
      'fromDate': fromDate?.millisecondsSinceEpoch,
      'toDate': toDate?.millisecondsSinceEpoch,
      'avgShippingPrice': avgShippingPrice,
      'avgShippingTime': avgShippingTime,
      'offerPercentage': offerPercentage,
      'imageURL': imageURL,
      'hits': hits,
      'validTill': validTill != null ? validTill!.millisecondsSinceEpoch : null,
      'isStaticAd': isStaticAd,
      'isVisible': isVisible,
      'offerLink': offerLink,
      'priceBefore': priceBefore,
      'priceAfter': priceAfter,
    };
  }

  factory OfferModule.fromMap(Map<String, dynamic> map, {String? uid}) {
    return OfferModule(
      uid: uid ?? (map['uid'] != null ? map['uid'] as String : null),
      shopUID: map['shopUID'] != null ? map['shopUID'] as String : null,
      name: map['name'] as String,
      shopDescription: map['shopDescription'] != null
          ? map['shopDescription'] as String
          : null,
      offerDescription: map['offerDescription'] != null
          ? map['offerDescription'] as String
          : null,
      categoryUIDs: List<String>.from((map['categoryUIDs'] as List<dynamic>)),
      fromDate: map['fromDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['fromDate'] as int)
          : null,
      toDate: map['toDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['toDate'] as int)
          : null,
      avgShippingPrice: map['avgShippingPrice'] != null
          ? map['avgShippingPrice'] as double
          : null,
      avgShippingTime: map['avgShippingTime'] != null
          ? map['avgShippingTime'] as String
          : null,
      offerPercentage: map['offerPercentage'] != null
          ? double.parse(map['offerPercentage'].toString())
          : null,
      imageURL: map['imageURL'] as String,
      hits: map['hits'] != null ? map['hits'] as int : null,
      validTill:
          map['validTill'] != null ? _handleTime(map['validTill']) : null,
      isStaticAd: map['isStaticAd'] != null ? map['isStaticAd'] as bool : null,
      isVisible: map['isVisible'] != null ? map['isVisible'] as bool : null,
      offerLink: map['offerLink'] != null ? map['offerLink'] as String : null,
      offerPercentageDescription: map['offerPercentageDescription'] != null
          ? map['offerPercentageDescription'] as String
          : null,
      priceBefore:
          map['priceBefore'] != null ? map['priceBefore'] as double : null,
      priceAfter:
          map['priceAfter'] != null ? map['priceAfter'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OfferModule.fromJson(String source) =>
      OfferModule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OfferModule(uid: $uid, shopUID: $shopUID, name: $name, shopDescription: $shopDescription, offerDescription: $offerDescription, offerPercentageDescription: $offerPercentageDescription, categoryUIDs: $categoryUIDs, fromDate: $fromDate, toDate: $toDate, avgShippingPrice: $avgShippingPrice, avgShippingTime: $avgShippingTime, offerPercentage: $offerPercentage, imageURL: $imageURL, hits: $hits, validTill: $validTill, isStaticAd: $isStaticAd, isVisible: $isVisible, offerLink: $offerLink, priceBefore: $priceBefore, priceAfter: $priceAfter)';
  }

  @override
  bool operator ==(covariant OfferModule other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.shopUID == shopUID &&
        other.name == name &&
        other.shopDescription == shopDescription &&
        other.offerDescription == offerDescription &&
        other.offerPercentageDescription == offerPercentageDescription &&
        listEquals(other.categoryUIDs, categoryUIDs) &&
        other.fromDate == fromDate &&
        other.toDate == toDate &&
        other.avgShippingPrice == avgShippingPrice &&
        other.avgShippingTime == avgShippingTime &&
        other.offerPercentage == offerPercentage &&
        other.imageURL == imageURL &&
        other.hits == hits &&
        other.validTill == validTill &&
        other.isStaticAd == isStaticAd &&
        other.isVisible == isVisible &&
        other.offerLink == offerLink &&
        other.priceBefore == priceBefore &&
        other.priceAfter == priceAfter;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        shopUID.hashCode ^
        name.hashCode ^
        shopDescription.hashCode ^
        offerDescription.hashCode ^
        offerPercentageDescription.hashCode ^
        categoryUIDs.hashCode ^
        fromDate.hashCode ^
        toDate.hashCode ^
        avgShippingPrice.hashCode ^
        avgShippingTime.hashCode ^
        offerPercentage.hashCode ^
        imageURL.hashCode ^
        hits.hashCode ^
        validTill.hashCode ^
        isStaticAd.hashCode ^
        isVisible.hashCode ^
        offerLink.hashCode ^
        priceBefore.hashCode ^
        priceAfter.hashCode;
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
