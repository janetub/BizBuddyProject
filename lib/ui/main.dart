import 'package:flutter/material.dart';
import 'main_pages/place_order.dart';
import 'main_pages/order_status.dart';
import 'main_pages/inventory_view.dart';
import '../../classes/all.dart';
import 'sidebar/sidebar.dart';


void main() => runApp(const MainCanvas());

class MainCanvas extends StatefulWidget {
  const MainCanvas({super.key});

  @override
  _MainCanvasState createState() => _MainCanvasState();
}
class _MainCanvasState extends State<MainCanvas>
{
  Widget _currentPage = PlaceOrderPage();

  void _onPageChanged(Widget page)
  {
    setState(() {
      _currentPage = page;
    });
  }

  // void _onFabPressed()
  // {
  //   if (_currentPage is PlaceOrderPage) {
  //   // handle FAB press on PlaceOrderPage
  //   } else if (_currentPage is OrderStatusPage) {
  //   // handle FAB press on OrderStatusPage
  //   } else if (_currentPage is InventoryPage) {
  //   // handle FAB press on InventoryPage
  //   }
  // }

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      home: Scaffold(
        drawer: Sidebar(
          onPageChanged: _onPageChanged,
        ),
        appBar: AppBar(
          backgroundColor: Colors.black54,
          centerTitle: true,
          title: const Text('BizBuddy',),
        ),
        body: Container(
          child: _currentPage,
        ),
      ),
    );
  }
}

