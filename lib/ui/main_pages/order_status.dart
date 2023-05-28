import 'package:flutter/material.dart';
import '../../classes/all.dart';

class OrderStatusPage extends StatelessWidget {
  final List<Order>? orders;

  OrderStatusPage({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: add customizable labels
        },
        backgroundColor: Colors.grey[400],
        elevation: 100,
        child: const Icon(
          Icons.add,
          color: Colors.black87,
          size: 30,
        ),
      ),
      body: orders == null || orders!.isEmpty
          ? const Center(
        child: Text(
          'No orders placed yet.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        itemCount: orders!.length,
        itemBuilder: (context, index) {
          Order order = orders![index];
          return ListTile(
            title: Text('Order #${order.orderId}'),
            subtitle:
            Text('Total Price: Php ${order.calculateTotalPrice()}'),
          );
        },
      ),
    );
  }
}