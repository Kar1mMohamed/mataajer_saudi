// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ShopModule {
  String? uid;
  String name;
  String description;
  String image;
  double? avgShippingPrice;
  String? avgShippingTime;
  String? cuponText;
  String? cuponCode;
  ShopModule({
    this.uid,
    required this.name,
    required this.description,
    required this.image,
    this.avgShippingPrice,
    this.avgShippingTime,
    this.cuponText,
    this.cuponCode,
  });

  ShopModule copyWith({
    String? uid,
    String? name,
    String? description,
    String? image,
    double? avgShippingPrice,
    String? avgShippingTime,
    String? cuponText,
    String? cuponCode,
  }) {
    return ShopModule(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      avgShippingPrice: avgShippingPrice ?? this.avgShippingPrice,
      avgShippingTime: avgShippingTime ?? this.avgShippingTime,
      cuponText: cuponText ?? this.cuponText,
      cuponCode: cuponCode ?? this.cuponCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'description': description,
      'image': image,
      'avgShippingPrice': avgShippingPrice,
      'avgShippingTime': avgShippingTime,
      'cuponText': cuponText,
      'cuponCode': cuponCode,
    };
  }

  factory ShopModule.fromMap(Map<String, dynamic> map) {
    return ShopModule(
      uid: map['uid'] != null ? map['uid'] as String : null,
      name: map['name'] as String,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopModule.fromJson(String source) =>
      ShopModule.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ShopModule(uid: $uid, name: $name, description: $description, image: $image, avgShippingPrice: $avgShippingPrice, avgShippingTime: $avgShippingTime, cuponText: $cuponText, cuponCode: $cuponCode)';
  }

  @override
  bool operator ==(covariant ShopModule other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.description == description &&
        other.image == image &&
        other.avgShippingPrice == avgShippingPrice &&
        other.avgShippingTime == avgShippingTime &&
        other.cuponText == cuponText &&
        other.cuponCode == cuponCode;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        description.hashCode ^
        image.hashCode ^
        avgShippingPrice.hashCode ^
        avgShippingTime.hashCode ^
        cuponText.hashCode ^
        cuponCode.hashCode;
  }
}
