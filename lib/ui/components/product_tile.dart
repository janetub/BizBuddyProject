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
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(15),
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
          borderRadius: BorderRadius.circular(15),
        ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(5,10,0,10),
            child: Column(
              children: [
                ListTile(
                  onTap: () => widget.onProductEdit(widget.item),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.item.name),
                      Text('₱ ${widget.item.price.toStringAsFixed(2)}'),
                    ],
                  ),
                  subtitle:
                  Text('Stocks: ${widget.item.quantity}\n${widget.item.description}',
                  maxLines: 2,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 50,
                        child: TextFormField(
                          controller: _quantityController,
                          decoration: InputDecoration(
                            labelText: 'Qty',
                            labelStyle: TextStyle(color: Colors.grey),
                            fillColor: Colors.white,
                            filled: true,
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
                        //padding: EdgeInsets.zero,
                        tooltip: "Add product to cart",
                        icon: Icon(
                          Icons.add_shopping_cart,
                          color: Color(0xFFEF911E),
                        ),
                        onPressed: () => widget.onAddToCart(widget.item, int.tryParse(_quantityController.text) ?? 1),
                      ),
                    ],
                  ),
                ),
                /*
                * TODO: remove tags, display during search
                * */
                if (widget.item.tags.isNotEmpty)
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                        child: Wrap(
                          spacing: 5,
                          alignment: WrapAlignment.start,
                          children: widget.item.tags.map((tag) =>
                              Text(
                                '#$tag',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              )
                          ).toList(),
                        ),
                      ),
                    ],
                  ),
              ],
            )
          ),
      ),
    );
  }
}