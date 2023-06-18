import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  final VoidCallback onProductCatalogSelected;
  final VoidCallback  onOrderStatusSelected;
  final VoidCallback  onInventorySelected;

  Sidebar({
    Key? key,
    required this.onProductCatalogSelected,
    required this.onOrderStatusSelected,
    required this.onInventorySelected,
  }) : super(key: key);

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {

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
                widget.onProductCatalogSelected();
                Navigator.pop(context);
              },
            ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Order Status'),
            onTap: () {
              widget.onOrderStatusSelected();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: const Text('Inventory'),
            onTap: () {
              widget.onInventorySelected();
              Navigator.pop(context);
            },
          ),
          // const Divider(
          //   thickness: .8,
          //   indent: 10,
          //   endIndent: 10,
          // ),
          // ListTile(
          //   leading: const Icon(Icons.notifications_none),
          //   title: const Text('Notifications'),
          //   onTap: () {},
          //   trailing: ClipOval(
          //     child: Container(
          //       color: Colors.red,
          //       width: 20,
          //       height: 20,
          //     ),
          //   ),
          // ),
          // ListTile(
          //   leading: const Icon(Icons.show_chart),
          //   title: const Text('Analytics'),
          //   onTap: () {},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.people_alt_outlined),
          //   title: const Text('Customer/Employees'),
          //   onTap: () {},
          // ),
          // const Divider(
          //   thickness: .8,
          //   indent: 10,
          //   endIndent: 10,
          // ),
          // ListTile(
          //   leading: const Icon(Icons.settings_outlined),
          //   title: const Text('Settings'),
          //   onTap: () {},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.help_outline),
          //   title: const Text('FAQ'),
          //   onTap: () {},
          // ),
          // ListTile(
          //   leading: const Icon(Icons.alternate_email),
          //   title: const Text('Contact Us'),
          //   onTap: () {},
          // ),
        ],
      ),
    );
  }
}
