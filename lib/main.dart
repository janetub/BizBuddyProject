import 'dart:collection';

import 'package:flutter/material.dart';
import 'ui/components/search_dialog.dart';
import 'ui/components/splash_screen.dart';
import 'ui/main_pages/product_catalog.dart';
import 'ui/main_pages/order_status.dart';
import 'ui/main_pages/inventory_view.dart';
import '../classes/all.dart';
import 'ui/sidebar/sidebar.dart';

void main() {
  runApp(MaterialApp(home: SplashScreen()));
}

class MainCanvas extends StatefulWidget {
  const MainCanvas({Key? key}) : super(key: key);

  @override
  _MainCanvasState createState() => _MainCanvasState();
}

class _MainCanvasState extends State<MainCanvas> {
  LinkedHashSet<Item> myProducts = LinkedHashSet<Item>();
  LinkedHashSet<Order> myOrders = LinkedHashSet<Order>();
  LinkedHashSet<Item> cartItems = LinkedHashSet<Item>();
  Widget? _currentPage;
  String _currentPageTitle = 'Product Catalog';
  VoidCallback? _onSearchButtonPressed;

  @override
  void initState() {
    super.initState();
    _currentPage = ProductCatalogPage(
      productCatalog: myProducts,
      cartItems: cartItems,
      navigateToOrderStatus: _navigateToOrderStatus,
      onPlaceOrder: (Order value) {},
      onSearchButtonPressed: (void Function() value) => _onSearchButtonPressed = value,
    );
  }

  void _navigateToOrderStatus() {
    setState(() {
      _currentPage = OrderStatusPage(orders: myOrders);
      _currentPageTitle = 'Order Status';
    });
  }

  void _onPageChanged(Widget page) {
    setState(() {
      _currentPage = page;
      if (page is ProductCatalogPage) {
        _currentPageTitle = 'Product Catalog';
      } else if (page is OrderStatusPage) {
        _currentPageTitle = 'Order Status';
      } else if (page is InventoryPage) {
        _currentPageTitle = 'Inventory View';
      } else {
        _currentPageTitle = 'BizBuddy';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            drawer: Sidebar(
              onPageChanged: _onPageChanged,
              myProducts: myProducts,
              myOrders: myOrders,
              cartItems: cartItems,
              onSearchButtonPressed: (void Function() value) => _onSearchButtonPressed = value,
            ),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xFFEEEDF1),
              centerTitle: true,
              title: Text(
                _currentPageTitle,
                style: TextStyle(color: Color(0xFF545454)),
              ),
              iconTheme: IconThemeData(color: Color(0xFF545454)),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    if(_currentPage is ProductCatalogPage) {
                      _onSearchButtonPressed?.call();
                    } else if (_currentPage is OrderStatusPage) {
                      // TODO
                    } else if (_currentPage is InventoryPage) {
                      // TODO
                    }
                  },
                ),
              ],
            ),
            body : Container(child : _currentPage)
        )
    );
  }
}
