class Item {
  String name;
  double _cost = 0;
  int _quantity = 1;
  DateTime? dateBought = DateTime.now();
  Set<String>? tags;

  Item(this.name, this.tags);

  double get cost => _cost;

  set cost(double value) {
    if (value >= 0) {
      _cost = value;
    } else {
      throw ArgumentError('Cost cannot be negative.');
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
}
