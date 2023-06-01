import 'package:flutter/material.dart';
import '../../classes/all.dart';

class ProductTile extends StatefulWidget {
  final Item item;
  final void Function(Item) onProductEdit;
  final void Function(Item) onProductDelete;
  final void Function(Item, int) onAddToCart;

  const ProductTile({
    Key? key,
    required this.item,
    required this.onProductEdit,
    required this.onProductDelete,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.item.name),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {
          return Future.value(false);
        }
        return Future.value(true);
      },
      background: Container(),
      secondaryBackground: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.delete),
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          widget.onProductDelete(widget.item);
        }
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: ListTile(
          onTap: () => widget.onProductEdit(widget.item),
          title: Text(widget.item.name),
          subtitle:
          Text('${widget.item.description} - Quantity: ${widget.item.quantity}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 60,
                child: TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(
                    labelText: 'Qty',
                    labelStyle: TextStyle(color: Colors.grey),
                    fillColor: Colors.white,
                    filled: true,
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
                        Colors.red)),
                  ),
                  keyboardType:
                  TextInputType.number,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () => widget.onAddToCart(widget.item, int.tryParse(_quantityController.text) ?? 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}