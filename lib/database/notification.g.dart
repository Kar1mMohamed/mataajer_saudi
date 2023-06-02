// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationModuleAdapter extends TypeAdapter<NotificationModule> {
  @override
  final int typeId = 2;

  @override
  NotificationModule read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationModule(
      index: fields[0] as int?,
      token: fields[1] as String?,
      title: fields[2] as String?,
      body: fields[3] as String?,
      date: fields[4] as DateTime,
      isRead: fields[5] as bool?,
      isActive: fields[6] as bool?,
      senderUserUID: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationModule obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.token)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.isRead)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.senderUserUID);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModuleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
