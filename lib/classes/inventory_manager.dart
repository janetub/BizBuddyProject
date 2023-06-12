/*
* This class manages the inventory of items.
* It keeps track of the available items and products and updates their availability when a new order is placed.
* */
import 'all.dart';
import 'dart:collection';

class Inventory {
  final LinkedHashSet<Item> _items = LinkedHashSet<Item>();

  bool updateItemQuantity(Item item, int quantity) {
    bool containsItem = _items.any((findItem) => findItem.name == item.name);
    if(containsItem) {
      Item foundItem = _items.firstWhere((cartItem) => cartItem.name == item.name);
      foundItem.quantity += quantity;
    }
    // else {
    //   Item newItem = item.duplicate();
    //   newItem.quantity = item.quantity;
    //   _items.add(newItem);
    // }
    return containsItem;
  }

  // void updateItem(Item item, {int? quantity, double? cost, double? markup}) {
  //   // Find the item in the set
  //   Item? foundItem = _items.firstWhere((i) => i.name == item.name, orElse: () => null);
  //   if (foundItem != null) {
  //     // Update the item's attributes
  //     if (quantity != null) {
  //       foundItem.quantity = quantity;
  //     }
  //     if (cost != null) {
  //       foundItem.cost = cost;
  //     }
  //     if (markup != null) {
  //       foundItem.markup = markup;
  //     }
  //   }
  // }

  void removeItem(Item item) {
    _items.remove(item);
  }

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

  LinkedHashSet<Item> getItems() {
    return LinkedHashSet<Item>.from(_items);
  }

  @override
  String toString() {
    String result = 'Inventory Items:\n';
    for (Item item in _items) {
      result += ' - $item\n';
    }
    return result;
  }
}