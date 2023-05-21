import 'package:flutter/cupertino.dart';
import '../navigation_manager.dart';

class OrderStatusPage extends StatelessWidget with NavigationStates
{
  OrderStatusPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return const Center(
      child: Text(
        'Orders placed will appear here.',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}