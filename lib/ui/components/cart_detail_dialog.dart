import 'package:flutter/material.dart';
import '../../classes/all.dart';
import 'cart_product_tile.dart';
import 'package:intl/intl.dart';
import 'dart:collection';

/*
* TODO: add product details dialog when clicked
* */

class CartDialog extends StatefulWidget {
  final LinkedHashSet<Item> cartItems;
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
  double get _totalPrice {
    return widget.cartItems.fold(0, (sum, item) => sum + item.calculateTotalValue());
  }

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
        child: Column(
          children: [
            Expanded(
              child: Scrollbar(
                isAlwaysShown: true,
                thickness: 3.0,
                interactive: true,
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
              )
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 5, 0), // Add padding to the top
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(text: 'Total Price: ',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          TextSpan(
                            text: '₱ ',
                            style: TextStyle(
                              color: Color(0xFF38823B),
                              fontSize: 18,
                              ),
                            ),
                          TextSpan(
                            text: '${NumberFormat('#,##0.00').format(_totalPrice)}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            primary: Colors.grey,
          ),
          onPressed: widget.onClose,
          child: const Text('Close'),
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