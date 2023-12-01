// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ItemModel {
  String? uid;
  final String name;
  String image;
  final String description;
  final String categoryUID;
  final DateTime createdDate;
  final double price;
  ItemModel({
    this.uid,
    required this.name,
    required this.image,
    required this.description,
    required this.categoryUID,
    required this.createdDate,
    required this.price,
  });

  ItemModel copyWith({
    String? uid,
    String? name,
    String? image,
    String? description,
    String? categoryUID,
    DateTime? createdDate,
    double? price,
  }) {
    return ItemModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      image: image ?? this.image,
      description: description ?? this.description,
      categoryUID: categoryUID ?? this.categoryUID,
      createdDate: createdDate ?? this.createdDate,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'image': image,
      'description': description,
      'categoryUID': categoryUID,
      'createdDate': createdDate.millisecondsSinceEpoch,
      'price': price,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] as String,
      image: map['image'] as String,
      description: map['description'] as String,
      categoryUID: map['categoryUID'] as String,
      createdDate:
          DateTime.fromMillisecondsSinceEpoch(map['createdDate'] as int),
      price: map['price'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemModel(uid: $uid, name: $name, image: $image, description: $description, categoryUID: $categoryUID, createdDate: $createdDate, price: $price)';
  }

  @override
  bool operator ==(covariant ItemModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.image == image &&
        other.description == description &&
        other.categoryUID == categoryUID &&
        other.createdDate == createdDate &&
        other.price == price;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        image.hashCode ^
        description.hashCode ^
        categoryUID.hashCode ^
        createdDate.hashCode ^
        price.hashCode;
  }
}
