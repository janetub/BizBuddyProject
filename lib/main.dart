import 'package:bizbuddyproject/ui/components/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/all_models.dart';
import 'ui/main_pages/all_main_pages.dart';
import '../classes/all_classes.dart';
import 'ui/sidebar/sidebar.dart';

late Box<Order> orderBox;
late Box<Item> productItemBox;
late Box<Item> cartItemBox;
late Box<Item> inventoryItemBox;

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(OrderAdapter());
  Hive.registerAdapter(OrderStatusAdapter());
  Hive.registerAdapter(ItemAdapter());
  orderBox = await Hive.openBox<Order>('orderBox');
  productItemBox = await Hive.openBox<Item>('productItemBox');
  cartItemBox = await Hive.openBox<Item>('cartItemBox');
  inventoryItemBox = await Hive.openBox<Item>('inventoryItemBox');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => InventoryModel(inventoryItemBox),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductCatalogModel(productItemBox),
        ),
        ChangeNotifierProvider(
          create: (context) => CartModel(cartItemBox),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderModel(orderBox),
        ),
      ],
      child: const MaterialApp(home: SplashScreen()),
    ),
  );
}

class MainCanvas extends StatefulWidget {
  const MainCanvas({Key? key}) : super(key: key);

  @override
  State<MainCanvas> createState() {
    return _MainCanvasState();
  }
}

class _MainCanvasState extends State<MainCanvas> {
  Widget? _currentPage;
  String _currentPageTitle = 'Product Catalog';
  final ValueNotifier<bool> _onPCSearchButtonPressed = ValueNotifier(false);
  final ValueNotifier<bool> _onOSsearchButtonPressed = ValueNotifier(false);
  final ValueNotifier<bool> _onInvSearchButtonPressed = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _currentPage = ProductCatalogPage(
      navigateToOrderStatus: () {
        _onPageChanged(
            OrderStatusPage(
              searchButtonPressed: _onOSsearchButtonPressed,
            ));
      },
      onMoveOrder: _onMoveOrder,
      searchButtonPressed: _onPCSearchButtonPressed,
    );
  }

  void _onMoveOrder(Order order) {
    final inventoryModel = Provider.of<InventoryModel>(context, listen: false);
    final orderModel = Provider.of<OrderModel>(context, listen: false);
    inventoryModel.updateForOrder(order);
    orderModel.addOrder(order);
  }


  void _onProductCatalogSelected() {
    _onPageChanged(ProductCatalogPage(
      navigateToOrderStatus: _onOrderStatusSelected,
      onMoveOrder: _onMoveOrder,
      searchButtonPressed: _onPCSearchButtonPressed,
    ));
  }

  void _onOrderStatusSelected() {
    _onPageChanged(
        OrderStatusPage(
          searchButtonPressed: _onOSsearchButtonPressed,
        ));
  }

  void _onInventorySelected() {
    _onPageChanged(
          InventoryPage(
            searchButtonPressed: _onInvSearchButtonPressed,
        ));
  }

  void _onPageChanged(Widget page) {
    setState(() {
      _currentPage = page;
      if (page is ProductCatalogPage) {
        _currentPageTitle = 'Product Catalog';
      } else if (page is OrderStatusPage) {
        _currentPageTitle = 'Order Status';
      } else if (page is InventoryPage) {
        _currentPageTitle = 'Inventory';
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
                style: const TextStyle(color: Color(0xFF545454)),
              ),
              iconTheme: const IconThemeData(color: Color(0xFF545454)),
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    splashRadius: 25, // custom splash radius
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if(_currentPage is ProductCatalogPage) {
                      _onPCSearchButtonPressed.value = !_onPCSearchButtonPressed.value;
                    } else if(_currentPage is OrderStatusPage) {
                      _onOSsearchButtonPressed.value = !_onOSsearchButtonPressed.value;
                    } else if(_currentPage is InventoryPage) {
                      _onInvSearchButtonPressed.value = !_onInvSearchButtonPressed.value;
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
