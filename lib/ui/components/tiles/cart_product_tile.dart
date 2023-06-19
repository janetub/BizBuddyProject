import 'package:bizbuddyproject/ui/components/all_components.dart';
import 'package:flutter/material.dart';
import '../../../classes/all_classes.dart';

class CartTile extends StatefulWidget {
  final Item item;
  final void Function(Item, int) onUpdateQuantity;

  const CartTile({
    Key? key,
    required this.item,
    required this.onUpdateQuantity,
  }) : super(key: key);

  @override
  State<CartTile> createState() {
    return _CartTileState();
  }
}

class _CartTileState extends State<CartTile> {
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.green,
      splashColor: Colors.orange,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ProductDetailsDialog(
              item: widget.item
          ),
        );
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0,5,0,7),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(widget.item.name),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child:
                  Text('Price ${widget.item.price.toStringAsFixed(2)}'),
                ),
              ],
            ),
            subtitle:
            Text('Quantity: ${widget.item.quantity}',
            style: const TextStyle(
                fontSize: 14,
                color: Colors.grey),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    cursorColor: const Color(0xFFEF911E),
                    controller:
                    _quantityController,
                    decoration:
                    InputDecoration(labelText:
                    'Qty',
                        labelStyle:
                        const TextStyle(color:
                        Colors.grey),
                        fillColor:
                        Colors.white,
                        filled:
                        true,
                        enabledBorder:
                        OutlineInputBorder(borderRadius:
                        BorderRadius.circular(15),
                            borderSide:
                            const BorderSide(color:
                            Colors.grey)),
                        focusedBorder:
                        OutlineInputBorder(borderRadius:
                        BorderRadius.circular(15),
                            borderSide:
                            const BorderSide(color:
                            Colors.grey)),
                        ),
                    keyboardType:
                    TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.remove,
                    color: Color(0xFFEF911E),
                  ),
                  onPressed: () {
                    final qty = _quantityController.text == '0'
                        ? 0
                        : int.tryParse(_quantityController.text) ?? 1;
                    widget.onUpdateQuantity(widget.item, qty);
                    _quantityController.clear();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}