/*
* This class manages the inventory of items.
* It keeps track of the available items and products and updates their availability when a new order is placed.
* */
import 'all.dart';

class Inventory {
  Set<Item> _items = {};

  void addItem(Item item) {
    _items.add(item);
  }

  Set<Item> searchItems(String query) {
    return _items.where((item) {
      final nameMatch = item.name.toLowerCase().contains(query.toLowerCase());
      final tagMatch = item.tags.any(
              (tag) => tag.toLowerCase().contains(query.toLowerCase()));
      return nameMatch || tagMatch;
    }).toSet();
  }

  bool isEmpty() {
    return _items.isEmpty;
  }
}