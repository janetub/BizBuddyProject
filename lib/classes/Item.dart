/*
* This class represents an item in the inventory and product in the product catalog.
* It can be a product to sell or a raw material.
 */

import 'dart:collection';

import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 3)
class Item extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  double _cost = 0;
  @HiveField(2)
  double _markup = 0;
  @HiveField(3)
  int _quantity = 0;
  @HiveField(4)
  DateTime? _dateAdded;
  @HiveField(5)
  LinkedHashSet<String> tags = LinkedHashSet<String>();
  @HiveField(6)
  String description;
  @HiveField(7)
  final LinkedHashSet<Item> _components = LinkedHashSet<Item>();

  Item(this.name, this.description) {
    dateAdded = DateTime.now();
  }

  double get cost {
    if (_components.isEmpty) {
      return _cost;
    } else {
      double totalCost = 0;
      for (Item component in _components) {
        totalCost += component.cost * component.quantity;
      }
      return totalCost;
    }
  }

  void addComponent(Item component) {
    final itemExists = _components.any((item) => item.name == component.name);

    if (itemExists) {
      final existingItem = _components.firstWhere((item) => item.name == component.name);
      existingItem.quantity += component.quantity;
    } else {
      _components.add(component);
    }
  }

  void removeComponent(Item component) {
    _components.remove(component);
  }

  LinkedHashSet<Item> get components {
    return _components;
  }

  set cost(double value) {
    if (value >= 0) {
      _cost = value;
    } else {
      throw ArgumentError('Cost cannot be negative.');
    }
  }

  double get price => cost + _markup;

  set markup(double value) {
    if (value >= 0) {
      _markup = value;
    } else {
      throw ArgumentError('Markup cannot be negative.');
    }
  }

  double calculateTotalPriceValue() {
    double totalValue = price * _quantity;
    for (Item component in _components) {
      totalValue += component.calculateTotalPriceValue();
    }
    return totalValue;
  }

  double calculateTotalCostValue() {
    return cost * _quantity;
  }

  DateTime? get dateAdded => _dateAdded;

  set dateAdded(DateTime? value) {
    if (value != null && value.isAfter(DateTime.now())) {
      throw ArgumentError('Date bought cannot be in the future.');
    }
    _dateAdded = value;
  }

  int get quantity => _quantity;

  set quantity(int newQuantity) {
    if (newQuantity >= 0) {
      _quantity = newQuantity;
    } else {
      throw ArgumentError('Quantity cannot be negative.');
    }
  }

  double getProfit() {
    return (price - cost) * _quantity;
  }

  bool isInStock() {
    return _quantity > 0;
  }

  Item duplicate() {
    Item newItem = Item(name, description);
    newItem._cost = _cost;
    newItem._markup = _markup;
    newItem._quantity = _quantity;
    newItem._dateAdded = _dateAdded;
    newItem.tags.addAll(tags);
    newItem._components.addAll(_components);
    return newItem;
  }

  @override
  String toString() {
    String result = 'Name: $name\nCost: $cost\nMarkup: $_markup\nQuantity: $_quantity\nDate Added: $_dateAdded\nTags: ${tags.join(", ")}\nDescription: $description\nComponents:\n';
    for (Item component in _components) {
      result += ' - $component\n';
    }
    return result;
  }
}