// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 3;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item(
      fields[0] as String,
      fields[6] as String,
    )
      .._cost = fields[1] as double
      .._markup = fields[2] as double
      .._quantity = fields[3] as int
      .._dateAdded = fields[4] as DateTime?
      ..tags = LinkedHashSet<String>.from((fields[5] as List).cast<String>());
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj._cost)
      ..writeByte(2)
      ..write(obj._markup)
      ..writeByte(3)
      ..write(obj._quantity)
      ..writeByte(4)
      ..write(obj._dateAdded)
      ..writeByte(5)
      ..write(obj.tags.toList())
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj._components.toList());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
