import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../models/all_models.dart';
import '../all_components.dart';

class CartDialog extends StatefulWidget {
  final VoidCallback onCheckoutOrder;

  const CartDialog({
    Key? key,
    required this.onCheckoutOrder,
  }) : super(key: key);

  @override
  State<CartDialog> createState() {
    return _CartDialogState();
  }
}

class _CartDialogState extends State<CartDialog> {

  @override
  void initState() {
    super.initState();
    final cartItems = Provider.of<CartModel>(context, listen: false).cartItems;
    for (final item in cartItems) {
      if(item.quantity<1) {
        cartItems.remove(item);
      }
    }
  }

  double get _totalPrice {
    return Provider.of<CartModel>(context, listen: false)
        .cartItems
        .fold(0, (sum, item) => sum + item.calculateTotalPriceValue());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFEEEDF1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text('Cart'),
      content: Provider.of<CartModel>(context).cartItems.isEmpty
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
                  thumbVisibility: true,
                  thickness: 3.0,
                  interactive: true,
                  child: ListView.builder(
                    itemCount: Provider.of<CartModel>(context).cartItems.length,
                    itemBuilder: (context, index) {
                      final item = Provider.of<CartModel>(context).cartItems.elementAt(index);
                      return CartTile(
                        item: item,
                        onUpdateQuantity: (item, quantity) {
                          if(quantity>0) {
                            if(item.quantity>=quantity) {
                              final itemDup = item.duplicate();
                              Provider.of<CartModel>(context, listen: false).removeItemQuantity(item, quantity);
                              Provider.of<ProductCatalogModel>(context, listen: false).addItemQuantity(itemDup, quantity);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    title: const Text('Invalid Quantity'),
                                    content: const Text(
                                        'The requested quantity to remove is not valid.'),
                                    actions: [
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          foregroundColor: const Color(0xFFEF911E),
                                        ),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          const TextSpan(text: 'Total Price: ',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const TextSpan(
                            text: '₱ ',
                            style: TextStyle(
                              color: Color(0xFF38823B),
                              fontSize: 18,
                            ),
                          ),
                          TextSpan(
                            text: NumberFormat('#,##0.00').format(_totalPrice),
                            style: const TextStyle(
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
            foregroundColor: Colors.grey,
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        if (Provider.of<CartModel>(context).cartItems.isNotEmpty)
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onCheckoutOrder();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: const Color(0xFF1AB428),
            ),
            child: const Column(
              children: [
                SizedBox(width: 4),
                Text('Checkout Order'),
              ],
            ),
          ),
        const SizedBox(width: 0),
      ],
    );
  }
}