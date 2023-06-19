import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/all_models.dart';
import '../all_components.dart';
import '../../../classes/all_classes.dart';

class InventorySearchDialog extends StatefulWidget {
  final void Function(Item item, int quantity) onAddToComponent;
  final Item? hideItem;

  const InventorySearchDialog({
    Key? key,
    required this.onAddToComponent,
    required this.hideItem,
  }) : super(key: key);

  @override
  State<InventorySearchDialog> createState() {
    return _InventorySearchDialogState();
  }
}

class _InventorySearchDialogState extends State<InventorySearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  LinkedHashSet<Item> _searchResults = LinkedHashSet<Item>();

  @override
  void initState() {
    super.initState();
    _searchResults = searchItems('');
  }

  LinkedHashSet<Item> searchItems(String query) {
    final inventory = Provider.of<InventoryModel>(context, listen: false).inventoryItems;
    return LinkedHashSet<Item>.from(inventory.where((item) {
      final nameMatch = item.name.toLowerCase().contains(query.toLowerCase());
      final tagMatch = item.tags.any(
              (tag) => tag.toLowerCase().contains(query.toLowerCase()));
      final isNotHideItem = widget.hideItem == null || item.name != widget.hideItem?.name;
      return (nameMatch || tagMatch) && isNotHideItem;
    }));
  }

  void _searchInventory(String query) {
    setState(() {
      _searchResults = searchItems(query);
    });
  }

  void _addToComponents(Item item, int quantity) {
    setState(() {
      widget.onAddToComponent(item, quantity);
      if(quantity > 0) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ($quantity) ${item.name} to components'),
            backgroundColor: const Color(0xFF616161),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 6.0,
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  Widget _buildContent() {
    if (Provider.of<InventoryModel>(context, listen: false).inventoryItems.isEmpty) {
      return const Text(
        'The inventory is currently empty.\nYou can add items by going to the inventory page in the sidebar.',
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      );
    } else if (_searchResults.isEmpty && _searchController.text.isEmpty) {
      return const Text(
        'No available items to add as components.',
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      );
    } else {
      return SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              cursorColor: const Color(0xFFEF911E),
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: const TextStyle(color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFFEF911E),
                ),
              ),
              onChanged: _searchInventory,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 3,
                interactive: true,
                child:
                ListView.builder(
                    itemCount:_searchResults.length,
                    itemBuilder:(context,index){
                      final item=_searchResults.elementAt(index);
                      return SearchResultTile(
                          item:item,
                          onAddToComponents:_addToComponents)
                      ;}),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFEEEDF1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: const Text('Search Inventory'),
      content: _buildContent(),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
              foregroundColor: Colors.grey
          ),
          child: const Text('Close'),
        ),
      ],
    );
  }
}