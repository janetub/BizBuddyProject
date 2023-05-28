import 'package:flutter/material.dart';
import '../classes/all.dart';
import '../ui/main_pages/product_catalog.dart';

class NavigationModel extends ChangeNotifier {
  Widget _currentPage = ProductCatalogPage(productCatalog: Set<Item>());

  Widget get currentPage => _currentPage;

  void navigateTo(Widget page) {
    _currentPage = page;
    notifyListeners();
  }
}