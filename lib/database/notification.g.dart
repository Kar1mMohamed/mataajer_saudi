// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalNotificationHiveAdapter extends TypeAdapter<LocalNotificationHive> {
  @override
  final int typeId = 1;

  @override
  LocalNotificationHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalNotificationHive(
      index: fields[0] as int?,
      token: fields[1] as String?,
      title: fields[2] as String?,
      body: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalNotificationHive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.token)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.body);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalNotificationHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
