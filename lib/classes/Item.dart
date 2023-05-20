class Item
{
  String name = '';
  double cost = 0;
  int quantity = 0;
  DateTime dateBought = DateTime.now();
  Set<String>? tags;

  Item(this.name, this.cost, this.quantity, this.dateBought, this.tags);
}