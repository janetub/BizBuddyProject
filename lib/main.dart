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
  VoidCallback? _onPCSearchButtonPressed;
  VoidCallback? _onOSSearchButtonPressed;

  @override
  void initState() {
    super.initState();
    _currentPage = ProductCatalogPage(
      productCatalog: myProducts,
      cartItems: cartItems,
      navigateToOrderStatus: () {
        _onPageChanged(
            OrderStatusPage(
                orders: myOrders,
              onSearchButtonPressed: (void Function() value) {  },
            ));
      },
      onMoveOrder: (order) {
        myOrders.add(order);
      },
      onSearchButtonPressed: (void Function() value) => _onPCSearchButtonPressed = value,
    );
  }


  void _onProductCatalogSelected() {
    _onPageChanged(ProductCatalogPage(
      productCatalog: myProducts,
      cartItems: cartItems,
      navigateToOrderStatus: _onOrderStatusSelected,
      onMoveOrder: (order) {
        myOrders.add(order);
      },
      onSearchButtonPressed: (void Function() value) => _onPCSearchButtonPressed = value,
    ));
  }

  void _onOrderStatusSelected() {
    _onPageChanged(
        OrderStatusPage(
            orders: myOrders,
          onSearchButtonPressed: (void Function() value) => _onOSSearchButtonPressed = value,
        ));
  }

  void _onInventorySelected() {
    _onPageChanged(InventoryPage());
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
              onProductCatalogSelected: _onProductCatalogSelected,
              onOrderStatusSelected: _onOrderStatusSelected,
              onInventorySelected: _onInventorySelected,
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
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: Icon(Icons.menu),
                    splashRadius: 25, // custom splash radius
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    if(_currentPage is ProductCatalogPage) {
                      _onPCSearchButtonPressed?.call();
                    } else if (_currentPage is OrderStatusPage) {
                      _onOSSearchButtonPressed?.call();
                    } else if (_currentPage is InventoryPage) {
                      // TODO
                    }
                  },
                  splashRadius: 25,
                ),
              ],
            ),
            body : Container(child : _currentPage)
        )
    );
  }
}
