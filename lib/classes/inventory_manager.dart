/*
* This class manages the inventory of items.
* It keeps track of the available items and products and updates their availability when a new order is placed.
* */
import 'all.dart';
import 'dart:collection';

class Inventory {
  final LinkedHashSet<Item> _items = LinkedHashSet<Item>();

  void addItem(Item item) {
    _items.add(item);
  }

  LinkedHashSet<Item> searchItems(String query) {
    return LinkedHashSet<Item>.from(_items.where((item) {
      final nameMatch = item.name.toLowerCase().contains(query.toLowerCase());
      final tagMatch = item.tags.any(
              (tag) => tag.toLowerCase().contains(query.toLowerCase()));
      return nameMatch || tagMatch;
    }));
  }

  bool isEmpty() {
    return _items.isEmpty;
  }
}