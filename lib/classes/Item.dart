/*
* This class represents an item in the inventory.
* It can be a product to sell or a raw material.
* Add attributes and methods to this class to manage the item’s availability and other details.
 */
class Item {
  String name;
  double _cost = 0;
  double _price = 0;
  int _quantity = 1;
  DateTime? _dateBought;
  DateTime? _dateSold;
  final Set<String> _tags = {};
  String description;
  Set<Item> components = {};

  Item(this.name, this.description)
  {
    dateBought = DateTime.now();
  }

  double get cost => _cost;

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

  DateTime? get dateSold => _dateSold;

  set dateSold(DateTime? value)
  {
    if(value != null && value.isBefore(_dateBought!))
      {
        throw ArgumentError("Date sold must not be earlier than date bought.");
      }
    _dateSold = value;
  }

  Set<String>? get tags => _tags;

  void addTag(String tag) => _tags.add(tag);
  void removeTag(String tag) => _tags.remove(tag);
  void addComponent(Item component) => components.add(component);
  void removeComponent(Item component) => components.remove(component);

  double getProfit()
  {
    return (_price - _cost) * _quantity;
  }

  bool isInStock()
  {
    return _quantity > 0;
  }

  void addQuantity(int quantityToAdd) {
    _quantity += quantityToAdd;
  }

  void removeQuantity(int quantityToRemove) {
    if ((_quantity - quantityToRemove) >= 0) {
      _quantity -= quantityToRemove;
    } else {
      throw ArgumentError('Quantity cannot be negative.');
    }
  }
}
