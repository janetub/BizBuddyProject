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
            title: const Text('Cart'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Button2'),
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
            leading: const Icon(Icons.shopping_cart_sharp),
            title: const Text('Button3'),
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