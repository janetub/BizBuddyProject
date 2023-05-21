import 'package:flutter/material.dart';

class OrderStatusPage extends StatelessWidget
{
  OrderStatusPage({super.key});

  @override
  Widget build(BuildContext context)
  {
    return const Center(
      child: Text(
        'No orders placed yet.',
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/*
class OrderStatusPage extends StatelessWidget with NavigationStates {
  OrderStatusPage({super.key});

  @override
  _orderStatusPageState createState() => _orderStatusPageState();
}

class _orderStatusPagestate extends State<OrderStatusPage>
{
  List <Order> _orders = [];

  @override
  Widget build(BuildContext context)
  {
    return Center(
      child: _orders.isEmpty
        ? const Text(
            'No orders placed yet.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        )
      : ListView.builder(
        itemCount: _orders.length,
        itemBuilder: (context, index)
        {
          final order = _orders[index];
          // build order item
        },
      ),
    );
  }
}
*/