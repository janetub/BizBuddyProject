// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 1;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      items: LinkedHashSet<Item>.from((fields[5] as List).cast<Item>()),
      recipient: fields[6] as Person,
    )
      ..description = fields[1] as String
      ..datePlaced = fields[2] as DateTime
      ..currentStatusIndex = fields[3] as int
      ..deliveryMethod = fields[7] as String
      ..statuses.addAll(LinkedHashSet<OrderStatus>.from((fields[8] as List).cast<OrderStatus>()));
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.datePlaced)
      ..writeByte(3)
      ..write(obj.currentStatusIndex)
      ..writeByte(4)
      ..write(obj.statuses.toList())
      ..writeByte(5)
      ..write(obj.items.toList())
      ..writeByte(6)
      ..write(obj.recipient)
      ..writeByte(7)
      ..write(obj.deliveryMethod)
      ..writeByte(8)
      ..write(obj.statuses.toList());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is OrderAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}

