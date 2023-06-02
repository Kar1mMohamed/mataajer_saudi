// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive/hive.dart';

part 'shop_fav.g.dart';

@HiveType(typeId: 1)
class ShopFavHive extends HiveObject {
  static const String boxName = 'shop_fav';
  static Future<Box<ShopFavHive>> openBox = Hive.openBox<ShopFavHive>(boxName);
  static Box<ShopFavHive> hiveBox = Hive.box<ShopFavHive>(boxName);

  @HiveField(0)
  String uid;
  @HiveField(1)
  String name;

  ShopFavHive(
    this.uid,
    this.name,
  );

  ShopFavHive copyWith({
    String? uid,
    String? name,
  }) {
    return ShopFavHive(
      uid ?? this.uid,
      name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
    };
  }

  factory ShopFavHive.fromMap(Map<String, dynamic> map) {
    return ShopFavHive(
      map['uid'] as String,
      map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopFavHive.fromJson(String source) =>
      ShopFavHive.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ShopFavHive(uid: $uid, name: $name)';

  @override
  bool operator ==(covariant ShopFavHive other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.name == name;
  }

  @override
  int get hashCode => uid.hashCode ^ name.hashCode;
}
