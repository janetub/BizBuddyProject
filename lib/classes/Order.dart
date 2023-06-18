import 'dart:collection';

import 'all_classes.dart';
/*
* This class represents a customer order.
* It can be pre-made or customized at the time the order is placed.
* Add attributes and methods to this class to manage the order’s status and other details.
* add feature typing number of quantity to order
* */

/*
*
* */

import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 1)
class Order extends HiveObject {
  @HiveField(0)
  final String orderId;
  @HiveField(1)
  String description;
  @HiveField(2)
  DateTime datePlaced;
  @HiveField(3)
  int currentStatusIndex;
  @HiveField(4)
  final LinkedHashSet<OrderStatus> statuses;
  @HiveField(5)
  final LinkedHashSet<Item> items;
  @HiveField(6)
  Person recipient;
  @HiveField(7)
  String deliveryMethod;

  Order({required this.items, required this.recipient}) : description = '', deliveryMethod = '', statuses = LinkedHashSet<OrderStatus>(), currentStatusIndex = -1, orderId = idGenerator(),
        datePlaced = DateTime.now() {
    if (items.isEmpty) {
      throw ArgumentError('An order must have at least one item.');
    }
    for (var item in items) {
      item.dateAdded = DateTime.now();
    }
  }

  double calculateOrderTotalValue() {
    double totalCost = 0;
    for (Item item in items) {
      totalCost += item.calculateTotalPriceValue();
    }
    return totalCost;
  }

  static String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  void addItem(Item item) {
    items.add(item);
    item.dateAdded = DateTime.now();
  }

  void removeItem(Item item) {
    items.remove(item);
  }

  void addStatus(OrderStatus status)
  {
    statuses.add(status);
  }

  double calculateTotalCost() {
    double totalCost = 0;
    for (Item item in items) {
      totalCost += item.cost * item.quantity;
    }
    return totalCost;
  }

  double calculateTotalPrice() {
    double totalPrice = 0;
    for (Item item in items) {
      totalPrice += item.price * item.quantity;
    }
    return totalPrice;
  }

  void nextStatus() {
    if (currentStatusIndex < statuses.length - 1) {
      currentStatusIndex++;
    }
  }

  void previousStatus() {
    if (currentStatusIndex > 0) {
      currentStatusIndex--;
    }
  }

  OrderStatus? getCurrentStatus() {
    if (currentStatusIndex >= 0 && currentStatusIndex < statuses.length) {
      return statuses.elementAt(currentStatusIndex);
    }
    return null;
  }

  @override
  String toString() {
    String result = 'Order Id: ${orderId}\nDescription: ${description}\nDateplace: ${datePlaced}, Current Status Index: ${currentStatusIndex}\nStatuses:\n';
    for (OrderStatus status in statuses) {
      result += ' - ${status}\n';
    }
    result += 'Items:\n';
    for (Item item in items) {
      result += ' - ${item}\n';
    }
    result += 'Recipient: ${recipient}\n';
    result += 'Delivery method: ${deliveryMethod}\n';
    return result;
  }

  Order copyWith({
      // LinkedHashSet<Item>? items,
      Person? recipient,
      String? description,
      // DateTime? datePlaced,
      // int? currentStatusIndex,
      LinkedHashSet<OrderStatus>? statuses,
      String? deliveryMethod,
    }) {
    this.description = description ?? this.description;
    // this.datePlaced = datePlaced ?? this.datePlaced;
    // this.currentStatusIndex = currentStatusIndex ?? this.currentStatusIndex;
    if (statuses != null) {
      this.statuses.clear();
      this.statuses.addAll(statuses);
    }
    // if (items != null) {
    //   this.items.clear();
    //   this.items.addAll(items);
    // }
    this.deliveryMethod = deliveryMethod ?? this.deliveryMethod;
    this.recipient = recipient ?? this.recipient;
    return this;
  }
}