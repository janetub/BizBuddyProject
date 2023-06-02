import 'package:flutter/material.dart';
import '../../classes/all.dart';
import 'cart_product_tile.dart';

/*
* TODO: add product details dialog when clicked
* */

class CartDialog extends StatefulWidget {
  final Set<Item> cartItems;
  final VoidCallback onClose;
  final VoidCallback onPlaceOrder;
  final void Function(Item, int) onUpdateQuantity;

  CartDialog({
    Key? key,
    required this.cartItems,
    required this.onClose,
    required this.onPlaceOrder,
    required this.onUpdateQuantity,
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
            final item = widget.cartItems.elementAt(index);
            return CartTile(
              item: item,
              onUpdateQuantity: widget.onUpdateQuantity,
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