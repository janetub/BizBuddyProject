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
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchInventory,
            ),
            SizedBox(height: 20),
            Expanded(
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