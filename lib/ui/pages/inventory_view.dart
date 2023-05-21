import 'package:flutter/material.dart';

class InventoryPage extends StatelessWidget
{
  InventoryPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return const Center(
      child: Text(
        "Inventory is empty.",
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}