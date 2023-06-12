import 'dart:collection';

import 'all.dart';
/*
* This class represents a customer order.
* It can be pre-made or customized at the time the order is placed.
* Add attributes and methods to this class to manage the order’s status and other details.
* add feature typing number of quantity to order
* */

/*
*
* */

class Order {
  final String orderId;
  String description;
  DateTime datePlaced;
  int currentStatusIndex;
  final LinkedHashSet<OrderStatus> statuses;
  final LinkedHashSet<Item> items;
  final Person recipient;
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
}