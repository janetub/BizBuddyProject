import 'package:flutter/material.dart';

class PlaceOrderPage extends StatelessWidget
{
  PlaceOrderPage({super.key});

  @override
  Widget build(BuildContext context)
  {
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
          'Ready to sell?\nStart adding products!',
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