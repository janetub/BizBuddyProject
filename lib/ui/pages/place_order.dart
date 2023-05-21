import 'package:flutter/material.dart';

class PlaceOrderPage extends StatelessWidget
{
  PlaceOrderPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return const Center(
      child: Text(
        'Ready to sell?\nStart adding products!',
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}