import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../classes/all_classes.dart';

class InventoryModel extends ChangeNotifier {
  final LinkedHashSet<Item> _inventoryItems;
  final Box<Item> _inventoryItemBox;

  InventoryModel(this._inventoryItemBox)
      : _inventoryItems = LinkedHashSet<Item>.from(_inventoryItemBox.values);

  LinkedHashSet<Item> get inventoryItems => _inventoryItems;

  void addItem(Item item) {
    _inventoryItems.add(item);
    _inventoryItemBox.add(item);
    notifyListeners();
  }

  bool removeItem(Item item) {
    bool hasItem = _inventoryItems.any((i) => i.name == item.name);
    if (hasItem) {
      Item foundItem = _inventoryItems.firstWhere((i) => i.name == item.name);
      _inventoryItems.remove(foundItem);
      final boxIndex = _inventoryItemBox.values.toList().indexOf(foundItem);
      if (boxIndex != -1) {
        _inventoryItemBox.deleteAt(boxIndex);
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  void updateItem(Item originalItem, Item updatedItem) {
    bool hasDuplicateItem = _inventoryItems.any((item) => item.name == originalItem.name);
    if (hasDuplicateItem) {
      Item duplicateItem = _inventoryItems.firstWhere((item) => item.name == originalItem.name);
      _inventoryItems.remove(duplicateItem);
      _inventoryItems.add(updatedItem);
      final boxIndex = _inventoryItemBox.values.toList().indexOf(duplicateItem);
      if (boxIndex != -1) {
        _inventoryItemBox.putAt(boxIndex, updatedItem);
      }
      notifyListeners();
    }
  }

  void updateForOrder(Order order) {
    for (final item in order.items) {
      bool itemFound = _inventoryItems.any((i) => i.name == item.name);
      if (itemFound) {
        Item existingItem = _inventoryItems.firstWhere((i) => i.name == item.name);
        existingItem.quantity -= item.quantity;
        final boxIndex = _inventoryItemBox.values.toList().indexOf(existingItem);
        if (boxIndex != -1) {
          _inventoryItemBox.putAt(boxIndex, existingItem);
        }
        notifyListeners();
      }
    }
  }

  bool updateItemQuantity(Item item, int quantity, bool isAdd) {
    if (quantity > 0) {
      bool itemFound = _inventoryItems.any((i) => i.name == item.name);
      if (itemFound) {
        Item existingItem = _inventoryItems.firstWhere((i) => i.name == item.name);
        if (!isAdd && existingItem.quantity - quantity >= 0) {
          existingItem.quantity -= quantity;
          final boxIndex = _inventoryItemBox.values.toList().indexOf(existingItem);
          if (boxIndex != -1) {
            _inventoryItemBox.putAt(boxIndex, existingItem);
          }
          notifyListeners();
          return true;
        } else if (isAdd) {
          existingItem.quantity += quantity;
          final boxIndex = _inventoryItemBox.values.toList().indexOf(existingItem);
          if (boxIndex != -1) {
            _inventoryItemBox.putAt(boxIndex, existingItem);
          }
          notifyListeners();
          return true;
        }
      }
    }
    return false;
  }

}