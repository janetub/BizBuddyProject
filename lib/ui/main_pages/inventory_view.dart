import 'package:flutter/material.dart';

class InventoryPage extends StatelessWidget {
  InventoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: Colors.grey[400],
        elevation: 100,
        child: const Icon(
          Icons.add,
          color: Colors.black87,
          size: 30,
        ),
      ),
      body: const Center(
        child: Text(
          "Inventory is empty.",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}