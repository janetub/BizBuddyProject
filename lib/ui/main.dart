import 'package:flutter/material.dart';
import 'components/splash_screen.dart';
import 'main_pages/product_catalog.dart';
import 'main_pages/order_status.dart';
import 'main_pages/inventory_view.dart';
import '../../classes/all.dart';
import 'sidebar/sidebar.dart';

void main() {
  runApp(MaterialApp(home: SplashScreen()));
}

class MainCanvas extends StatefulWidget {
  const MainCanvas({Key? key}) : super(key: key);

  @override
  _MainCanvasState createState() => _MainCanvasState();
}

class _MainCanvasState extends State<MainCanvas> {
  Set<Item> myProducts = <Item>{};
  Set<Order> myOrders = <Order>{};
  Set<Item> cartItems = <Item>{};
  Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = ProductCatalogPage(
      productCatalog: myProducts,
      cartItems: cartItems,
      navigateToOrderStatus: _navigateToOrderStatus,
      onPlaceOrder: (Order value) {},
    );
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
          cartItems: cartItems,
        ),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFEEEDF1),
          centerTitle: true,
          title: Text(
            'BizBuddy',
            style: TextStyle(color: Color(0xFF545454)),
          ),
          iconTheme: IconThemeData(color: Color(0xFF545454)),
        ),
        body: Container(
          child: _currentPage,
        ),
      ),
    );
  }
}
