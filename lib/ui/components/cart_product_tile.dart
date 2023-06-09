import 'package:bizbuddyproject/ui/components/product_details_dialog.dart';
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
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(widget.item.name),
              ),
              Flexible(
                child: Text('₱ ${widget.item.price.toStringAsFixed(2)}'),
              ),
            ],
          ),
          subtitle:
          Text('Quantity: ${widget.item.quantity}',
          style: TextStyle(
              fontSize: 14,
              color: Colors.grey),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 50,
                child: TextFormField(
                  cursorColor: Color(0xFFEF911E),
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
                      BorderRadius.circular(15),
                          borderSide:
                          BorderSide(color:
                          Colors.grey)),
                      focusedBorder:
                      OutlineInputBorder(borderRadius:
                      BorderRadius.circular(15),
                          borderSide:
                          BorderSide(color:
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
                  final newQuantity = _quantityController.text == '0'
                      ? 0
                      : int.tryParse(_quantityController.text) ?? 1;
                  widget.onUpdateQuantity(widget.item, newQuantity);
                  if (widget.item.quantity == 0) {
                    widget.onRemove();
                  }
                  _quantityController.clear();
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}