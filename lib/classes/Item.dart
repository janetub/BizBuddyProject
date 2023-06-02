/*
* TODO:
* This class represents an item in the inventory.
* It can be a product to sell or a raw material.
* Add necessary attributes and methods to this class to manage the item’s availability and other details.
 */
class Item {
  String name;
  double _cost = 0;
  double _price = 0;
  int _quantity = 0;
  DateTime? _dateBought;
  final Set<String> _tags = {};
  String description;
  Set<Item> components = {};

  Item(this.name, this.description)
  {
    dateBought = DateTime.now();
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

  double get price => _price;

  set price(double value) {
    if (value >= 0) {
      _price = value;
    } else {
      throw ArgumentError('Price cannot be negative.');
    }
  }

  double calculateTotalValue() => _price * _quantity;

  DateTime? get dateBought => _dateBought;

  set dateBought(DateTime? value) {
    if (value != null && value.isAfter(DateTime.now())) {
      throw ArgumentError('Date bought cannot be in the future.');
    }
    _dateBought = value;
  }

  Set<String>? get tags => _tags;

  void addTag(String tag) => _tags.add(tag);
  void removeTag(String tag) => _tags.remove(tag);
  void addComponent(Item component) => components.add(component);
  void removeComponent(Item component) => components.remove(component);

  int get quantity => _quantity;

  set quantity(int newQuantity) {
    if (newQuantity >= 0) {
      _quantity = newQuantity;
    } else {
      throw ArgumentError('Quantity cannot be negative.');
    }
  }

  double getProfit()
  {
    return (price - cost) * _quantity;
  }

  bool isInStock()
  {
    return _quantity > 0;
  }

  Item duplicate() {
    Item newItem = Item(name, description);
    newItem._cost = _cost;
    newItem._price = _price;
    newItem._quantity = 0;
    newItem._dateBought = _dateBought;
    newItem._tags.addAll(_tags);
    newItem.components.addAll(components);
    return newItem;
  }
}
