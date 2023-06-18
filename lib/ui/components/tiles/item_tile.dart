import 'package:bizbuddyproject/ui/components/all_components.dart';
import 'package:flutter/material.dart';
import '../../../classes/all_classes.dart';

class ItemTile extends StatefulWidget {
  final Item item;
  final void Function(Item) onItemEdit;
  final void Function(Item) onItemDelete;
  final void Function(Item, int, bool) onQuantityChanged;

  const ItemTile({
    Key? key,
    required this.item,
    required this.onItemEdit,
    required this.onItemDelete,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<ItemTile> createState() {
    return _ItemTileState();
  }
}

class _ItemTileState extends State<ItemTile> {
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.green,
      splashColor: Colors.orange,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ItemDetailsDialog(
              item: widget.item
          ),
        );
      },
      child: Dismissible(
        key: UniqueKey(),
        confirmDismiss: (direction) {
          if (direction == DismissDirection.startToEnd) {
            widget.onItemEdit(widget.item);
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
            widget.onItemDelete(widget.item);
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
                                child: Text(
                                    widget.item.name,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child:
                            Text('Cost: ₱ ${widget.item.cost.toStringAsFixed(2)}'),
                          ),
                        ],
                      ),
                      subtitle:
                      Text(
                        'Stocks: ${widget.item.quantity}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // SizedBox(
                          //   width: 50,
                          //   height: 40,
                          //   child: IconButton(
                          //     //padding: EdgeInsets.zero,
                          //     tooltip: 'Add to product catalog',
                          //     icon: Icon(
                          //       Icons.playlist_add,
                          //       color: Color(0xFFEF911E),
                          //     ),
                          //     onPressed: () {
                          //       /// TODO
                          //     },
                          //   ),
                          // ),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              //padding: EdgeInsets.zero,
                              tooltip: 'Remove quantity',
                              icon: const Icon(
                                Icons.remove,
                                color: Color(0xFFEF911E),
                              ),
                              onPressed: () {
                                int qty = int.tryParse(_quantityController.text) ?? 1;
                                widget.onQuantityChanged(widget.item, qty, false);
                                // if (qty <= widget.item.quantity) {
                                //   _quantityController.clear();
                                // }
                                _quantityController.clear();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            height: 50,
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
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              //padding: EdgeInsets.zero,
                              tooltip: 'Add quantity',
                              icon: const Icon(
                                Icons.add,
                                color: Color(0xFFEF911E),
                              ),
                              onPressed: () {
                                int qty = int.tryParse(_quantityController.text) ?? 1;
                                widget.onQuantityChanged(widget.item, qty, true);
                                _quantityController.clear();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if(widget.item.description.isNotEmpty)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
                        child: Text(
                          widget.item.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black54,
                          ),
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