import 'package:bizbuddyproject/ui/components/all_components.dart';
import 'package:flutter/material.dart';
import '../../../classes/all_classes.dart';

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
  State<ProductTile> createState() {
    return _ProductTileState();
  }
}

class _ProductTileState extends State<ProductTile> {
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
      child: Dismissible(
        key: UniqueKey(),
        confirmDismiss: (direction) {
          if (direction == DismissDirection.startToEnd) {
            widget.onProductEdit(widget.item);
            return Future.value(false);
          }
          return Future.value(true);
        },
        background: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.green,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Icon(Icons.edit),
              ),
            ),
          ),
        ),
        secondaryBackground: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.red,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(15),
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
              padding: const EdgeInsets.fromLTRB(5,10,0,10),
              child: Column(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 7,
                                child: Text(widget.item.name),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child:
                            Text('Price: ${widget.item.price.toStringAsFixed(2)}'),
                          ),
                        ],
                      ),
                      subtitle:
                      Text(
                        'Stocks: ${widget.item.quantity}${widget.item.description.isNotEmpty
                                ? '\n${widget.item.description}'
                                : ''}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 70,
                            child: TextFormField(
                              cursorColor: const Color(0xFFEF911E),
                              controller: _quantityController,
                              decoration: InputDecoration(
                                labelText: 'Qty',
                                labelStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
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
                            //padding: EdgeInsets.zero,
                            tooltip: "Add product to cart",
                            icon: const Icon(
                              Icons.add_shopping_cart,
                              color: Color(0xFFEF911E),
                            ),
                            onPressed: () {
                              widget.onAddToCart(widget.item, int.tryParse(_quantityController.text) ?? 1);
                              int qty = int.tryParse(_quantityController.text) ?? 1;
                              if(qty <= widget.item.quantity) {
                                _quantityController.clear();
                              }
                            }
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (widget.item.tags.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                        child: Wrap(
                          spacing: 5,
                          alignment: WrapAlignment.start,
                          children: widget.item.tags.map((tag) =>
                              Text(
                                '#$tag',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.start,
                              )
                          ).toList(),
                        ),
                      ),
                    ),
                ],
              )
            ),
        ),
      ),
    );
  }
}