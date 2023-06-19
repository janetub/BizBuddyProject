import 'dart:collection';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:bizbuddyproject/ui/components/all_components.dart';
import '../../../classes/all_classes.dart';
import '../../../models/all_models.dart';

class SearchResultTile extends StatefulWidget {
  final Item item;
  final void Function(Item item, int quantity) onAddToComponents;

  const SearchResultTile({
    Key? key,
    required this.item,
    required this.onAddToComponents,
  }) : super(key: key);

  @override
  State<SearchResultTile> createState() {
    return _SearchResultTileState();
  }
}

class _SearchResultTileState extends State<SearchResultTile> {
  final TextEditingController _quantityController = TextEditingController();

  int _calculateCurrentMaxStocks(bool hasComponents) {
    int maxProducts = 0;
    LinkedHashSet<Item> tempInventory = LinkedHashSet<Item>.from(
      Provider.of<InventoryModel>(context, listen: false).inventoryItems.map((item) => item.duplicate()),
    ); // deep copy

    // no components, reduce tempInventory by items in cart
    if(!hasComponents) {
      for (Item cartItem in Provider.of<CartModel>(context, listen: false).cartItems) {
        bool itemFound = tempInventory.any((i) => i.name == cartItem.name);
        if (itemFound) { // found item match in cart
          Item foundItem = tempInventory.firstWhere((i) => i.name == cartItem.name);
          foundItem.quantity -= cartItem.quantity;
        }
      }
      for (Item prodCatItem in Provider.of<ProductCatalogModel>(context, listen: false).productCatalog) {
        bool itemFound = tempInventory.any((i) => i.name == prodCatItem.name);
        if (itemFound) { // found item match in catalog
          Item foundItem = tempInventory.firstWhere((i) => i.name == prodCatItem.name);
          foundItem.quantity -= prodCatItem.quantity;
        }
      }
    }

    // has components and check each if in catalog or cart
    if(hasComponents) {
      for (Item item in widget.item.components) {
        bool cartItemFound = Provider.of<CartModel>(context, listen: false).cartItems.any((c) => c.name == item.name);
        if(cartItemFound) { // found in cart
          Item cartItem = Provider.of<CartModel>(context, listen: false).cartItems.firstWhere((c) => c.name == item.name);
          bool itemFound = tempInventory.any((i) => i.name == cartItem.name);
          if (itemFound) { // confirm match of cartItem in inventory
            Item foundItem = tempInventory.firstWhere((i) => i.name == cartItem.name);
            foundItem.quantity -= cartItem.quantity; // reduce from invTemp
          }
        }
        bool prodCatItemFound = Provider.of<ProductCatalogModel>(context, listen: false).productCatalog.any((p) => p.name == item.name);
        if(prodCatItemFound) { // component found in catalog
          Item prodItem = Provider.of<ProductCatalogModel>(context, listen: false).productCatalog.firstWhere((c) => c.name == item.name);
          bool itemFound = tempInventory.any((i) => i.name == prodItem.name);
          if (itemFound) { // confirm match of catItem in inventory
            Item foundItem = tempInventory.firstWhere((i) => i.name == prodItem.name);
            foundItem.quantity -= prodItem.quantity; // reduce from invTemp
          }
        }
      }
    }

    // has components and check max producible from inventory
    if (hasComponents) {
      while (true) {
        bool canCreateProduct = true;
        for (Item item in widget.item.components) {
          bool itemFound = tempInventory.any((i) => i.name == item.name);
          if (itemFound) {
            Item foundItem = tempInventory.firstWhere((i) => i.name == item.name);
            if (foundItem.quantity >= item.quantity) {
              foundItem.quantity -= item.quantity;
            } else {
              canCreateProduct = false;
              break;
            }
          } else {
            canCreateProduct = false;
            break;
          }
        }
        if (canCreateProduct) {
          maxProducts += 1;
        } else {
          break;
        }
      }
    } else { // no components and check max producible from inventory
      bool itemFound = tempInventory.any((i) => i.name == widget.item.name);
      if (itemFound) {
        Item foundItem = tempInventory.firstWhere((i) => i.name == widget.item.name);
        maxProducts = foundItem.quantity;
      }
    }
    // print(maxProducts);
    return maxProducts;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.green,
      splashColor: Colors.orange,
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
          padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
          child: Column(
            children: [
              ListTile(
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
                      Text('Price ${widget.item.cost.toStringAsFixed(2)}'),
                    ),
                  ],
                ),
                subtitle: Text('Inventory: ${_calculateCurrentMaxStocks(widget.item.components.isNotEmpty)}'),
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
                      tooltip: "Add as component of the product",
                      icon: const Icon(
                        Icons.add,
                        color: Color(0xFFEF911E),
                      ),
                      onPressed: () {
                        final itemDup = widget.item.duplicate();
                        itemDup.quantity = _calculateCurrentMaxStocks(widget.item.components.isNotEmpty);
                        widget.onAddToComponents(itemDup, int.tryParse(_quantityController.text) ?? 1);
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
                          style: const TextStyle(
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
