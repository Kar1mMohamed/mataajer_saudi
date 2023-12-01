// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:mataajer_saudi/app/data/modules/item_model.dart';

class CartModel {
  int quantity = 1;
  final ItemModel itemModel;
  CartModel({
    this.quantity = 1,
    required this.itemModel,
  });

  double get totalAmount => quantity * itemModel.price;

  static List<CartModel> cacheCartModelFromJson(String str) =>
      List<CartModel>.from(json.decode(str).map((x) => CartModel.fromJson(x)));

  static String cacheCartModelToJson(List<CartModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  CartModel copyWith({
    int? quantity,
    ItemModel? itemModel,
  }) {
    return CartModel(
      quantity: quantity ?? this.quantity,
      itemModel: itemModel ?? this.itemModel,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quantity': quantity,
      'itemModel': itemModel.toMap(),
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      quantity: map['quantity'] as int,
      itemModel: ItemModel.fromMap(map['itemModel'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'CartModel(quantity: $quantity, itemModel: $itemModel)';

  @override
  bool operator ==(covariant CartModel other) {
    if (identical(this, other)) return true;

    return other.quantity == quantity && other.itemModel == itemModel;
  }

  @override
  int get hashCode => quantity.hashCode ^ itemModel.hashCode;
}
