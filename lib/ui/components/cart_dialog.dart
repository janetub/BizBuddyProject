import 'package:flutter/material.dart';

import '../../classes/item.dart';

class CartDialog extends StatefulWidget {
  final List<Item> cartItems;
  final VoidCallback onClose;
  final VoidCallback onPlaceOrder;

  CartDialog({
    Key? key,
    required this.cartItems,
    required this.onClose,
    required this.onPlaceOrder,
  }) : super(key: key);

  @override
  _CartDialogState createState() => _CartDialogState();
}

class _CartDialogState extends State<CartDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFE5E5E5),
      title: const Text('Cart'),
      content: widget.cartItems.isEmpty
          ? const Text('Your cart is empty.')
          : SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: widget.cartItems.length,
          itemBuilder: (context, index) {
            final item = widget.cartItems[index];
            return Card(
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(item.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        // Add item logic
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        // Remove item logic
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: widget.onClose,
        ),
        if (widget.cartItems.isNotEmpty)
          TextButton(
            child: const Text('Place Order'),
            onPressed: widget.onPlaceOrder,
          ),
      ],
    );
  }
}
