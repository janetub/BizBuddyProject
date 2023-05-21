import 'package:flutter/cupertino.dart';
import '../navigation_manager.dart';

class PlaceOrderPage extends StatelessWidget with NavigationStates
{
  PlaceOrderPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return const Center(
      child: Text(
        'Ready to sell?\nStart adding products!',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}