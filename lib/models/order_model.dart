import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../classes/all_classes.dart';

class OrderModel extends ChangeNotifier {
  final LinkedHashSet<Order> _orders;
  final Box<Order> _orderBox;

  OrderModel(this._orderBox)
    : _orders = LinkedHashSet<Order>.from(_orderBox.values);

  LinkedHashSet<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
    _orderBox.add(order);
    notifyListeners();
  }

  bool removeOrder(Order order) {
    bool orderFound = _orders.any((o) => o.orderId == order.orderId);
    if (orderFound) {
      Order exisitngOrder = _orders.firstWhere((o) => o.orderId == order.orderId);
      _orders.remove(exisitngOrder);
      final boxIndex = _orderBox.values.toList().indexOf(exisitngOrder);
      if (boxIndex != -1) {
        _orderBox.deleteAt(boxIndex);
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  bool updateOrder(Order order) {
    bool orderFound = _orders.any((o) => o.orderId == order.orderId);
    if (orderFound) {
      Order exisitngOrder = _orders.firstWhere((o) => o.orderId == order.orderId);
      _orders.remove(exisitngOrder);
      _orders.add(order);
      final boxIndex = _orderBox.values.toList().indexOf(exisitngOrder);
      if (boxIndex != -1) {
        _orderBox.putAt(boxIndex, order);
      }
      notifyListeners();
      return true;
    }
    print('${order.orderId}');
    return false;
  }
}