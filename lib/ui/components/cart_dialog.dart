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
      backgroundColor: const Color(0xFFEEEDF1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text('Cart'),
      content: widget.cartItems.isEmpty
          ? const Text(
        'Your cart is empty.',
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      )
          : SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: widget.cartItems.length,
          itemBuilder: (context, index) {
            final item = widget.cartItems.elementAt(index);
            return CartTile(
              item: item,
              onUpdateQuantity: widget.onUpdateQuantity,
              onRemove: () {
                setState(() {
                  widget.cartItems.remove(item);
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Close'),
          style: TextButton.styleFrom(
            primary: Colors.grey,
          ),
          onPressed: widget.onClose,
        ),
        if (widget.cartItems.isNotEmpty)
          ElevatedButton(
            onPressed: widget.onPlaceOrder,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Color(0xFF1AB428),
            ),
            child: const Column(
              children: [
                SizedBox(width: 4),
                Text('Place Order'),
              ],
            ),
          ),
        SizedBox(width: 0),
      ],
    );
  }
}