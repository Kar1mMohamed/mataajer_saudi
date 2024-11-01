// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:mataajer_saudi/app/data/modules/category_module.dart';
import 'package:mataajer_saudi/app/data/modules/choose_subscription_module.dart';

class AppSettings {
  List<CategoryModule> categories;
  List<ChooseSubscriptionModule> subscriptions;
  List<String> admins;

  /// THIS METHOD IS TO AVOID APPLE STORE IN-APP PURCHASE
  bool? isVersionRelease;
  AppSettings({
    required this.categories,
    required this.subscriptions,
    required this.admins,
    this.isVersionRelease,
  });

  AppSettings copyWith({
    List<CategoryModule>? categories,
    List<ChooseSubscriptionModule>? subscriptions,
    List<String>? admins,
    bool? isVersionRelease,
  }) {
    return AppSettings(
      categories: categories ?? this.categories,
      subscriptions: subscriptions ?? this.subscriptions,
      admins: admins ?? this.admins,
      isVersionRelease: isVersionRelease ?? this.isVersionRelease,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'categories': categories.map((x) => x.toMap()).toList(),
      'subscriptions': subscriptions.map((x) => x.toMap()).toList(),
      'admins': admins,
      'isVersionRelease': isVersionRelease,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      categories: List<CategoryModule>.from(
        (map['categories'] as List<dynamic>).map<CategoryModule>(
          (x) => CategoryModule.fromMap(x as Map<String, dynamic>),
        ),
      ),
      subscriptions: List<ChooseSubscriptionModule>.from(
        (map['subscriptions'] as List<dynamic>).map<ChooseSubscriptionModule>(
          (x) => ChooseSubscriptionModule.fromMap(x as Map<String, dynamic>),
        ),
      ),
      admins: List<String>.from((map['admins'] as List<dynamic>)),
      isVersionRelease: map['isVersionRelease'] != null
          ? map['isVersionRelease'] as bool
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppSettings.fromJson(String source) =>
      AppSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AppSettings(categories: $categories, subscriptions: $subscriptions, admins: $admins, isVersionRelease: $isVersionRelease)';
  }

  @override
  bool operator ==(covariant AppSettings other) {
    if (identical(this, other)) return true;

    return listEquals(other.categories, categories) &&
        listEquals(other.subscriptions, subscriptions) &&
        listEquals(other.admins, admins) &&
        other.isVersionRelease == isVersionRelease;
  }

  @override
  int get hashCode {
    return categories.hashCode ^
        subscriptions.hashCode ^
        admins.hashCode ^
        isVersionRelease.hashCode;
  }
}
