import 'dart:math';

import 'package:bizbuddyproject/ui/components/item_tile.dart';
import 'package:flutter/material.dart';

import 'dart:collection';

import 'package:flutter/material.dart';
import '../components/cart_dialog.dart';
import '../components/product_tile.dart';
import '../input_forms/add_item.dart';
import '../../classes/all.dart';
import '../input_forms/add_order.dart';
import '../input_forms/edit_item.dart';

class InventoryPage extends StatefulWidget {
  final Inventory inventoryItems;
  final ValueChanged<VoidCallback> onSearchButtonPressed;

  InventoryPage({
    Key? key,
    required this.onSearchButtonPressed,
    required this.inventoryItems,
  }) : super(key: key);

  @override
  _InventoryPageState createState() => _InventoryPageState();
}

/*
* TODO: changes made here are reflected in product catalog and vise versa, items added from product catalog is also added here
* */

class _InventoryPageState extends State<InventoryPage> {

  final TextEditingController _searchController = TextEditingController();
  LinkedHashSet<Item> _displayedItems = LinkedHashSet<Item>();
  final ScrollController _scrollController = ScrollController();
  bool _isSearchFieldVisible = false;
  String _selectedSortOption = 'Default';
  final List<String> _sortOptions = ['Default', 'Name', 'Cost', 'Date added', 'Stocks'];
  final List<IconData> _sortOptionIcons = [
    Icons.sort,
    Icons.sort_by_alpha,
    Icons.money,
    Icons.date_range,
    Icons.inventory,
  ];
  bool _isAscending = true;

  // TODO: for debugging, remove later
  @override
  void initState() {
    super.initState();
    widget.onSearchButtonPressed(_searchButtonPressed);

    _displayedItems = widget.inventoryItems.getItems();
  }

  void _searchButtonPressed() {
    setState(() {
      _isSearchFieldVisible = !_isSearchFieldVisible;
    });
  }

  LinkedHashSet<Item> searchItems(String query) {
    return LinkedHashSet<Item>.from(widget.inventoryItems.getItems().where((item) {
      final nameMatch = item.name.toLowerCase().contains(query.toLowerCase());
      final tagMatch = item.tags.any(
              (tag) => tag.toLowerCase().contains(query.toLowerCase()));
      return nameMatch || tagMatch;
    }));
  }

  void _performSearch(String query) {
    setState(() {
      _displayedItems = searchItems(query);
    });
  }

  void _clearSearchField() {
    setState(() {
      _searchController.clear();
      _displayedItems = widget.inventoryItems.getItems();
    });
  }

  LinkedHashSet<Item> sortItems(String sortOption, bool isAscending) {
    List<Item> sortedItems = _displayedItems.toList();
    if (sortOption == 'Name') {
      int extractNumber(String str) {
        return int.parse(str.replaceAll(RegExp(r'\D'), ''));
      }
      sortedItems.sort((a, b) {
        int aNumber = extractNumber(a.name);
        int bNumber = extractNumber(b.name);
        return isAscending ? aNumber.compareTo(bNumber) : bNumber.compareTo(aNumber);
      });
    } else if (sortOption == 'Cost') {
      sortedItems.sort((a, b) => isAscending ? a.cost.compareTo(b.cost) : b.cost.compareTo(a.cost));
    } else if (sortOption == 'Date added') {
      sortedItems.sort((a, b) => isAscending ? a.dateAdded!.compareTo(b.dateAdded!) : b.dateAdded!.compareTo(a.dateAdded!));
    } else if (sortOption == 'Stocks') {
      sortedItems.sort((a, b) => isAscending ? a.quantity.compareTo(b.quantity) : b.quantity.compareTo(a.quantity));
    } else {
      if (!isAscending) {
        sortedItems = (widget.inventoryItems.getItems().toList()).reversed.toList();
      } else {
        sortedItems = widget.inventoryItems.getItems().toList();
      }
    }
    return LinkedHashSet.from(sortedItems);
  }

  void _performSort(String sortOption, bool isAscending) {
    setState(() {
      _displayedItems = sortItems(sortOption, isAscending);
    });
  }

  void _showAddItemPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddItemPage(
            onSubmit: (item) {
              setState(() {
                if (widget.inventoryItems.getItems().any((existingItem) => existingItem.name == item.name)) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Duplicate Item'),
                      content: Text('An item with the same name already exists in the inventory.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
                widget.inventoryItems.addItem(item);
              });
            }, inventory: widget.inventoryItems,
          ),
        )
    );
  }

  void _onItemEdit(Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemPage(
          item: item,
          onSubmit: (editedItem) {
            setState(() {
              widget.inventoryItems.removeItem(item);
              widget.inventoryItems.addItem(editedItem);
            });
          }, inventory: widget.inventoryItems,
        ),
      ),
    );
  }

  void _onItemDelete(Item item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              style: TextButton.styleFrom(
                primary: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  Navigator.of(dialogContext).pop();
                });
              },
            ),
            TextButton(
              child: const Text('Delete'),
              style: TextButton.styleFrom(
                primary: Colors.red,
              ),
              onPressed: () {
                try {
                  setState(() {
                    widget.inventoryItems.removeItem(item);
                  });
                  Navigator.of(dialogContext).pop();
                } catch (e) {
                  // display a dialog indicating the error
                  showDialog(
                    context: context,
                    builder: (BuildContext errorDialogContext) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content:
                        Text('An error occurred while deleting the item. Please try again.'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(errorDialogContext).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _onUpdateQuantity(Item item, int quantity, bool isAdd) {
   if(quantity > 0) {
     if(item.quantity - quantity >= 0 && !isAdd) {
       setState(() {
         widget.inventoryItems.updateItemQuantity(item, -quantity);
       });
     } else if (isAdd) {
       setState(() {
         widget.inventoryItems.updateItemQuantity(item, quantity);
       });
     } else {
       showDialog(
         context: context,
         builder: (BuildContext dialogContext) {
           return AlertDialog(
             title: const Text('Invalid Quantity'),
             content: const Text(
                 'The requested quantity to remove is not valid.'),
             actions: [
               TextButton(
                 child: const Text('OK'),
                 style: TextButton.styleFrom(
                   primary: Color(0xFFEF911E),
                 ),
                 onPressed: () {
                   Navigator.of(dialogContext).pop();
                 },
               ),
             ],
           );
         },
       );
     }
   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEDF1),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // FloatingActionButton(
          //   onPressed: (){}, // TODO
          //   backgroundColor: Color(0xFFEF911E),
          //   elevation: 1,
          //   child: const Icon(
          //     Icons.playlist_add,
          //     color: Colors.white,
          //     size: 30,
          //   ),
          //   heroTag: 'addToProductCatalog',
          //   tooltip: 'Add an item to product catalog',
          // ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _showAddItemPage,
            backgroundColor: Color(0xFF1AB428),
            elevation: 1,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            heroTag: 'addButton',
            tooltip: 'Add an item',
          ),
        ],
      ),
      body: Center(
        child: widget.inventoryItems.isEmpty()
            ? const Text(
          'Inventory is empty.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        )
            : Column(
          children: [
            SizedBox(
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 16,
                    ),
                    onPressed: () {
                      setState(() {
                        _isAscending = !_isAscending;
                        _performSort(_selectedSortOption, _isAscending);
                      });
                    },
                    splashRadius: 15,
                  ),
                  DropdownButton<String>(
                    dropdownColor: Colors.white,
                    value: _selectedSortOption,
                    items: _sortOptions.asMap().entries.map((entry) {
                      int index = entry.key;
                      String item = entry.value;
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                            Icon(
                              _sortOptionIcons[index],
                              color: Colors.black38,
                              size: 18,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSortOption = newValue!;
                        _performSort(newValue, _isAscending);
                      });
                    },
                    underline: SizedBox(),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ],
              ),
            ),
            if(_isSearchFieldVisible)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
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
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: _clearSearchField,
                      color: Color(0xFFEF911E),
                    ),
                  ),
                  onChanged: _performSearch,
                ),
              ),
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  scrollbarTheme: ScrollbarThemeData(
                    thumbColor: MaterialStateProperty.all(Colors.black54),
                  ),
                ),
                child: Scrollbar(
                  controller: _scrollController,
                  isAlwaysShown: true,
                  thickness: 3,
                  interactive: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _displayedItems.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _displayedItems.length) {
                        return Container(height: kFloatingActionButtonMargin + 120);
                      }
                      final item = _displayedItems.elementAt(index);
                      return ItemTile(
                          item: item,
                          onItemEdit: _onItemEdit,
                          onItemDelete: _onItemDelete,
                        onQuantityChanged: _onUpdateQuantity,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}