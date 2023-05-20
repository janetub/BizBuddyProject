import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  NavBar({Key? key}) : super(key: key);

    final SampleNum sampleNum = SampleNum(); // reference cannot be changed

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // removes whitespace above the header
        children: [
          const UserAccountsDrawerHeader(
            accountName: null,
            accountEmail: null,
            decoration:  BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'images/BizBuddy_Header_zoomed.png',
                ),
                fit: BoxFit.cover,
              )
            ),
            ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            // Image.asset(
            //     'images/cart.png',
            //     width: 35.0,
            //     height: 35.0,
            // ),
            title: const Text('Place Orders'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.assignment_outlined),
            title: const Text('Order Status'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: const Text('Inventory'),
            onTap: () {},
          ),
          const Divider(
            thickness: .8,
            indent: 10,
            endIndent: 10,
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {},
            trailing: ClipOval(
              child: Container(
                color: Colors.red,
                width: 20,
                height: 20,
                child: Center(
                  child: Text(
                    '${sampleNum.num}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
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
            leading: const Icon(Icons.settings),
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

class SampleNum {
  int num = 67;
  int get number => num;
}