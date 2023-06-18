import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../classes/all_classes.dart';

class CartModel extends ChangeNotifier {
  final LinkedHashSet<Item> _cartItems;
  final Box<Item> _cartItemBox;

  CartModel(this._cartItemBox)
    : _cartItems = LinkedHashSet<Item>.from(_cartItemBox.values);

  LinkedHashSet<Item> get cartItems => _cartItems;

  void addItem(Item item) {
    _cartItems.add(item);
    _cartItemBox.add(item);
    notifyListeners();
  }

  bool removeItem(Item item) {
    bool hasItem = _cartItems.any((i) => i.name == item.name);
    if (hasItem) {
      Item foundItem = _cartItems.firstWhere((i) => i.name == item.name);
      _cartItems.remove(foundItem);
      final boxIndex = _cartItemBox.values.toList().indexOf(foundItem);
      if (boxIndex != -1) {
        _cartItemBox.deleteAt(boxIndex);
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeItemQuantity(Item item, int quantity) {
    if (quantity > 0) {
      if (item.quantity >= quantity) {
        item.quantity -= quantity;
        if (item.quantity == 0) {
          removeItem(item);
        } else {
          // Check if the item exists in the _cartItemBox
          if (_cartItemBox.values.any((element) => element == item)) {
            // Find the index of the item in the _cartItemBox
            final boxIndex = _cartItemBox.values.toList().indexWhere((element) => element == item);
            _cartItemBox.putAt(boxIndex, item);
          }
        }
        notifyListeners();
      }
    }
  }

  void updateItem(Item originalItem, Item updatedItem) {
    bool foundItem = _cartItems.any((item) => item.name == originalItem.name);
    if (foundItem) {
      Item duplicateItem = _cartItems.firstWhere((item) => item.name == originalItem.name);
      _cartItems.remove(duplicateItem);
      _cartItems.add(updatedItem);
      final boxIndex = _cartItemBox.values.toList().indexOf(duplicateItem);
      if (boxIndex != -1) {
        _cartItemBox.putAt(boxIndex, updatedItem);
      }
      notifyListeners();
    }
  }

  void clear() {
    _cartItems.clear();
    _cartItemBox.clear();
    notifyListeners();
  }
}