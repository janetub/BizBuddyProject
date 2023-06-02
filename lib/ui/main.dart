import 'package:flutter/material.dart';
import 'main_pages/product_catalog.dart';
import 'main_pages/order_status.dart';
import 'main_pages/inventory_view.dart';
import '../../classes/all.dart';
import 'sidebar/sidebar.dart';

void main() => runApp(const MainCanvas());

class MainCanvas extends StatefulWidget {
  const MainCanvas({Key? key}) : super(key: key);

  @override
  _MainCanvasState createState() => _MainCanvasState();
}

class _MainCanvasState extends State<MainCanvas> {
  Set<Item> myProducts = <Item>{};
  Set<Order> myOrders = <Order>{};
  Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = ProductCatalogPage(productCatalog: myProducts, navigateToOrderStatus: _navigateToOrderStatus, onPlaceOrder: (Order value) {  },);
  }

  void _navigateToOrderStatus() {
    setState(() {
      _currentPage = OrderStatusPage(orders: myOrders);
    });
  }

  void _onPageChanged(Widget page) {
    setState(() {
      _currentPage = page;
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
        ),
        appBar: AppBar(
          backgroundColor: Colors.black54,
          centerTitle: true,
          title: const Text(
            'BizBuddy',
          ),
        ),
        body: Container(
          child: _currentPage,
        ),
      ),
    );
  }
}
