import 'package:flutter/material.dart';
import '../../classes/all.dart';
import '../main_pages/product_catalog.dart';
import '../main_pages/order_status.dart';
import '../main_pages/inventory_view.dart';

class Sidebar extends StatelessWidget {
  final ValueChanged<Widget> onPageChanged;
  final Set<Item> myProducts;
  final Set<Order> myOrders;
  final Set<Item> cartItems;
  final ValueChanged<VoidCallback> onSearchButtonPressed;

  Sidebar({
    Key? key,
    required this.onPageChanged,
    required this.myProducts,
    required this.myOrders,
    required this.cartItems,
    required this.onSearchButtonPressed,
  }) : super(key: key);

  void _addOrder(Order order) {
    myOrders.add(order);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: null,
            accountEmail: null,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'images/banner.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
            ListTile(
              leading: const Icon(Icons.add_shopping_cart),
              title: const Text('Product Catalog'),
              onTap: () {
                onPageChanged(ProductCatalogPage(
                  productCatalog: myProducts,
                  cartItems: cartItems,
                  navigateToOrderStatus: () => onPageChanged(OrderStatusPage(orders: myOrders)),
                  onPlaceOrder: _addOrder,
                  onSearchButtonPressed: onSearchButtonPressed,
                ));
                Navigator.pop(context);
              },
            ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Order Status'),
            onTap: () {
              onPageChanged(OrderStatusPage(orders: myOrders));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: const Text('Inventory'),
            onTap: () {
              onPageChanged(InventoryPage());
              Navigator.pop(context);
            },
          ),
          const Divider(
            thickness: .8,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            leading: const Icon(Icons.notifications_none),
            title: const Text('Notifications'),
            onTap: () {},
            trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,
                height: 20,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.show_chart),
            title: const Text('Analytics'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.people_alt_outlined),
            title: const Text('Customer/Employees'),
            onTap: () {},
          ),
          const Divider(
            thickness: .8,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('FAQ'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.alternate_email),
            title: const Text('Contact Us'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
