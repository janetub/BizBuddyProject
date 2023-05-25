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

  int get quantity => _quantity;

  set quantity(int value) {
    if (value >= 1) {
      _quantity = value;
    } else {
      throw ArgumentError('Quantity must be at least 1.');
    }
  }

  DateTime? get dateBought => _dateBought;

  set dateBought(DateTime? value) => dateBought = value;

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
}
