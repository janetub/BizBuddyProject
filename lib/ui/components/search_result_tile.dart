import 'package:bizbuddyproject/ui/components/product_details_dialog.dart';
import 'package:flutter/material.dart';
import '../../classes/all.dart';

class SearchResultTile extends StatefulWidget {
  final Item item;
  final void Function(Item item, int quantity) onAddToComponents;

  const SearchResultTile({
    Key? key,
    required this.item,
    required this.onAddToComponents,
  }) : super(key: key);

  @override
  _SearchResultTileState createState() => _SearchResultTileState();
}

class _SearchResultTileState extends State<SearchResultTile> {
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => ProductDetailsDialog(item: widget.item),
        );
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 10, 0, 10),
          child: Column(
            children: [
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                        child: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(text: widget.item.name,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              TextSpan(text: '  '),
                              TextSpan(
                                text: '₱ ',
                                style: TextStyle(
                                  color: Color(0xFF38823B),
                                  fontSize: 18,
                                ),
                              ),
                              TextSpan(
                                text: '${widget.item.cost.toStringAsFixed(2)}',
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
                      tooltip: "Add as component of the product",
                      icon: Icon(
                        Icons.add,
                        color: Color(0xFFEF911E),
                      ),
                      onPressed: () {
                        widget.onAddToComponents(widget.item, int.tryParse(_quantityController.text) ?? 1);
                        _quantityController.clear();
                      }
                    ),
                  ],
                ),
              ),
              if (widget.item.tags.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
        ),
      ),
    );
  }
}
