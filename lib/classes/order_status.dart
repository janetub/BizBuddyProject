/*
* This class represents the status of an order.
* Allow entrepreneurs to create their own statuses and labels for different stages of the order processing.
* */

import 'package:hive/hive.dart';

part 'order_status.g.dart';

@HiveType(typeId: 2)
class OrderStatus extends HiveObject {
  @HiveField(0)
  String label;
  @HiveField(1)
  String description;

  OrderStatus({required this.label, required this.description});

  @override
  String toString() {
    return 'Label: ${label}, Description: ${description}\n';
  }
}