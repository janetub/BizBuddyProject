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
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(5, 10, 0, 10),
        child: Column(
          children: [
            ListTile(
              onTap: (){}, // TODO: view product detail
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.item.name),
                  Text('₱ ${widget.item.price}'),
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
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
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
        ),
      ),
    );
  }
}
