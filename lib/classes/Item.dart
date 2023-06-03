/*
* This class represents an item in the inventory.
* It can be a product to sell or a raw material.
 */

class Item {
  String name;
  double _cost = 0;
  double _markup = 0;
  int _quantity = 0;
  DateTime? _dateAdded;
  Set<String> tags = {};
  String description;
  Set<Item> components = {};

  Item(this.name, this.description) {
    dateAdded = DateTime.now();
  }

  double get cost {
    if (components.isEmpty) {
      return _cost;
    } else {
      double totalCost = 0;
      for (Item component in components) {
        totalCost += component.cost;
      }
      return totalCost;
    }
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

  double calculateTotalValue() {
    double totalValue = price * _quantity;
    for (Item component in components) {
      totalValue += component.calculateTotalValue();
    }
    return totalValue;
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
    newItem._quantity = 0;
    newItem._dateAdded = _dateAdded;
    newItem.tags.addAll(tags);
    newItem.components.addAll(components);
    return newItem;
  }
}