import 'package:flutter/material.dart';
import '../../classes/all.dart';

class CartTile extends StatefulWidget {
  final Item item;
  final void Function(Item, int) onUpdateQuantity;
  final VoidCallback onRemove;

  const CartTile({
    Key? key,
    required this.item,
    required this.onUpdateQuantity,
    required this.onRemove,
  }) : super(key: key);

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(widget.item.name),
        subtitle:
        Text('${widget.item.description} - Quantity: ${widget.item.quantity}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 50,
              child: TextFormField(
                controller:
                _quantityController,
                decoration:
                InputDecoration(labelText:
                'Qty',
                    labelStyle:
                    TextStyle(color:
                    Colors.grey),
                    fillColor:
                    Colors.white,
                    filled:
                    true,
                    enabledBorder:
                    OutlineInputBorder(borderRadius:
                    BorderRadius.circular(10),
                        borderSide:
                        BorderSide(color:
                        Colors.grey)),
                    focusedBorder:
                    OutlineInputBorder(borderRadius:
                    BorderRadius.circular(10),
                        borderSide:
                        BorderSide(color:
                        Colors.grey)),
                    errorBorder:
                    OutlineInputBorder(borderRadius:
                    BorderRadius.circular(10),
                        borderSide:
                        BorderSide(color:
                        Colors.red)),
                    focusedErrorBorder:
                    OutlineInputBorder(borderRadius:
                    BorderRadius.circular(10),
                        borderSide:
                        BorderSide(color:
                        Colors.red))),
                keyboardType:
                TextInputType.number,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                final newQuantity =
                    int.tryParse(_quantityController.text) ?? 1;
                widget.onUpdateQuantity(widget.item, newQuantity);
                if (widget.item.quantity <= 1) {
                  widget.onRemove();
                }
                _quantityController.clear();
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}