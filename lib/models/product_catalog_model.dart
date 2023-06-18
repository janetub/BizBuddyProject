import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../classes/all_classes.dart';

class ProductCatalogModel extends ChangeNotifier {
  final LinkedHashSet<Item> _productCatalog;
  final Box<Item> _productItemBox;

  ProductCatalogModel(this._productItemBox)
      : _productCatalog = LinkedHashSet<Item>.from(_productItemBox.values);

  LinkedHashSet<Item> get productCatalog => _productCatalog;
  LinkedHashSet<Item> get productCatalogItemBox => LinkedHashSet.from(_productItemBox.values);

  void addItem(Item item) {
    _productCatalog.add(item);
    _productItemBox.add(item);
    notifyListeners();
  }

  bool removeItem(Item item) {
    bool hasItem = _productCatalog.any((i) => i.name == item.name);
    if (hasItem) {
      Item foundItem = _productCatalog.firstWhere((i) => i.name == item.name);
      _productCatalog.remove(foundItem);
      final boxIndex = _productItemBox.values.toList().indexOf(foundItem);
      if (boxIndex != -1) {
        _productItemBox.deleteAt(boxIndex);
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeItemQuantity(Item item, int quantity) {
    if (quantity > 0) {
      bool containsItem = _productCatalog.any((catalogItem) => catalogItem.name == item.name);
      if (containsItem) {
        Item catalogItem = _productCatalog.firstWhere((catalogItem) => catalogItem.name == item.name);
        catalogItem.quantity -= quantity;
        final index = _productItemBox.values.toList().indexOf(catalogItem);
        _productItemBox.putAt(index, catalogItem);
      }
      notifyListeners();
    }
  }

  void addItemQuantity(Item item, int quantity) {
    if (quantity > 0) {
      bool containsItem = _productCatalog.any((catalogItem) => catalogItem.name == item.name);
      if (containsItem) {
        Item catalogItem = _productCatalog.firstWhere((catalogItem) => catalogItem.name == item.name);
        catalogItem.quantity += quantity;
        final index = _productItemBox.values.toList().indexOf(catalogItem);
        _productItemBox.putAt(index, catalogItem);
      } else {
        Item newItem = item.duplicate();
        newItem.quantity = item.quantity;
        addItem(newItem);
        final index = _productItemBox.values.toList().indexOf(item);
        if (index < 0) { //not found
          _productItemBox.add(item);
        } else {
          _productItemBox.putAt(index, item);
        }
      }
      notifyListeners();
    }
  }

  void updateItem(Item originalItem, Item updatedItem) {
    bool hasOrigItem = _productCatalog.any((item) => item.name == originalItem.name);
    if (hasOrigItem) {
      Item duplicateItem = _productCatalog.firstWhere((item) => item.name == originalItem.name);
      _productCatalog.remove(duplicateItem);
      _productCatalog.add(updatedItem);
      final boxIndex = _productItemBox.values.toList().indexOf(duplicateItem);
      if (boxIndex != -1) {
        _productItemBox.putAt(boxIndex, updatedItem);
      }
      notifyListeners();
    }
  }

  void copyItemQuantity(Item item) {
    bool containsItem = _productCatalog.any((catalogItem) => catalogItem.name == item.name);
    if (containsItem) {
      Item catalogItem = _productCatalog.firstWhere((catalogItem) => catalogItem.name == item.name);
      catalogItem.quantity = item.quantity;
      final index = _productItemBox.values.toList().indexOf(catalogItem);
      _productItemBox.putAt(index, catalogItem);
      notifyListeners();
    }
  }
}