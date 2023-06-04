import 'package:bizbuddyproject/ui/components/search_result_tile.dart';
import 'package:flutter/material.dart';
import '../../classes/all.dart';

class InventorySearchDialog extends StatefulWidget {
  final Inventory inventory;
  final void Function(Item item, int quantity) onAddToComponent;

  const InventorySearchDialog({
    Key? key,
    required this.inventory,
    required this.onAddToComponent,
  }) : super(key: key);

  @override
  _InventorySearchDialogState createState() => _InventorySearchDialogState();
}

class _InventorySearchDialogState extends State<InventorySearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  Set<Item> _searchResults = {};

  @override
  void initState() {
    super.initState();
    _searchResults = widget.inventory.searchItems('');
  }

  void _searchInventory(String query) {
    setState(() {
      _searchResults = widget.inventory.searchItems(query);
    });
  }

  void _addToComponents(Item item, int quantity) {
    setState(() {
      widget.onAddToComponent(item, quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFEEEDF1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      title: Text('Search Inventory'),
      content: widget.inventory.isEmpty()
        ? const Text(
        'The inventory is currently empty.\nYou can add items by going to the inventory page in the sidebar.',
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
      )
      : SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              cursorColor: Color(0xFFEF911E),
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(color: Colors.grey),
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFFEF911E),
                ),
              ),
              onChanged: _searchInventory,
            ),
            SizedBox(height: 20),
            Expanded(
                child: Scrollbar(
                  isAlwaysShown: true,
                  thickness: 3,
                  interactive: true,
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final item = _searchResults.elementAt(index);
                      return SearchResultTile(
                        item: item,
                        onAddToComponents: _addToComponents,
                      );
                    },
                  ),
                )
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
              'Close',
          ),
          style: TextButton.styleFrom(
            primary: Colors.grey
          ),
        ),
      ],
    );
  }
}