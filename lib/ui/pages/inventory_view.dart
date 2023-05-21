import 'package:flutter/cupertino.dart';
import '../navigation_manager.dart';

class InventoryPage extends StatelessWidget with NavigationStates
{
  InventoryPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return const Center(
      child: Text(
        'Your stocks will appear here.',
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
      ),
    );
  }
}