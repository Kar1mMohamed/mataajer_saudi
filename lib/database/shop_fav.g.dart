// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_fav.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopFavHiveAdapter extends TypeAdapter<ShopFavHive> {
  @override
  final int typeId = 1;

  @override
  ShopFavHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopFavHive(
      fields[0] as String,
      fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShopFavHive obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopFavHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
