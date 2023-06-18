import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:provider/provider.dart';
import 'package:bizbuddyproject/ui/components/all_components.dart';
import '../../models/all_models.dart';
import '../input_forms/all_input_forms.dart';
import '../../classes/all_classes.dart';

/*
* TODO: changes made here are reflected in product catalog and vise versa, items added from product catalog is also added here
* */

class InventoryPage extends StatefulWidget {
  final ValueNotifier<bool> searchButtonPressed;

  const InventoryPage({
    Key? key,
    required this.searchButtonPressed,
  }) : super(key: key);

  @override
  State<InventoryPage> createState() {
    return _InventoryPageState();
  }
}

class _InventoryPageState extends State<InventoryPage> {

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final inventoryNotifier = ValueNotifier<LinkedHashSet<Item>>(
    LinkedHashSet<Item>(),
  );

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

  @override
  void initState() {
    super.initState();
    widget.searchButtonPressed.addListener(_searchButtonPressed);
    final inventoryData = Provider.of<InventoryModel>(context, listen: false).inventoryItems;
    inventoryNotifier.value = inventoryData;
    print('Inv setState____________');
    for (final item in Provider.of<InventoryModel>(context, listen: false).inventoryItems) {
      print(item);
    }
  }

  @override
  void dispose() {
    widget.searchButtonPressed.removeListener(_searchButtonPressed);
    super.dispose();
  }

  void _searchButtonPressed() {
    setState(() {
      _isSearchFieldVisible = !_isSearchFieldVisible;
    });
  }

  LinkedHashSet<Item> searchItems(String query) {
    return LinkedHashSet<Item>.from(Provider.of<InventoryModel>(context, listen: false).inventoryItems.where((item) {
      final nameMatch = item.name.toLowerCase().contains(query.toLowerCase());
      final tagMatch = item.tags.any(
              (tag) => tag.toLowerCase().contains(query.toLowerCase()));
      return nameMatch || tagMatch;
    }));
  }

  void _performSearch(String query) {
    setState(() {
      inventoryNotifier.value = searchItems(query);
    });
  }

  void _clearSearchField() {
    setState(() {
      inventoryNotifier.value = Provider.of<InventoryModel>(context, listen: false).inventoryItems;
      _searchController.clear();
    });
  }

  LinkedHashSet<Item> sortItems(String sortOption, bool isAscending) {
    List<Item> sortedItems = inventoryNotifier.value.toList();
    if (sortOption == 'Name') {
      sortedItems.sort((a, b) {
        // Compare the lowercase versions of the item names
        int comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
        // Reverse the comparison result if sorting in descending order
        return isAscending ? comparison : -comparison;
      });
    } else if (sortOption == 'Price') {
      sortedItems.sort((a, b) => isAscending ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
    } else if (sortOption == 'Date bought') {
      sortedItems.sort((a, b) => isAscending ? a.dateAdded!.compareTo(b.dateAdded!) : b.dateAdded!.compareTo(a.dateAdded!));
    } else if (sortOption == 'Stocks') {
      sortedItems.sort((a, b) => isAscending ? a.quantity.compareTo(b.quantity) : b.quantity.compareTo(a.quantity));
    } else {
      if (!isAscending) {
        sortedItems = (Provider.of<ProductCatalogModel>(context, listen: false).productCatalog.toList()).reversed.toList();
      } else {
        sortedItems = Provider.of<ProductCatalogModel>(context, listen: false).productCatalog.toList();
      }
    }
    return LinkedHashSet.from(sortedItems);
  }

  void _performSort(String sortOption, bool isAscending) {
    setState(() {
      inventoryNotifier.value = sortItems(sortOption, isAscending);
    });
  }

  void _showAddItemPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddItemPage(
            callingPage: widget,
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
          callingPage: widget,
        ),
      ),
    );
  }

  void _onItemDelete(Item item) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  Navigator.of(dialogContext).pop();
                });
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () {
                try {
                  setState(() {
                    Provider.of<InventoryModel>(context, listen: false).removeItem(item);
                    Provider.of<ProductCatalogModel>(context, listen: false).removeItem(item);
                    Provider.of<CartModel>(context, listen: false).removeItem(item);
                  });
                  Navigator.of(dialogContext).pop();
                } catch (e) {
                  // display a dialog indicating the error
                  showDialog(
                    context: context,
                    builder: (BuildContext errorDialogContext) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        title: const Text('Error'),
                        content:
                        const Text('An error occurred while deleting the item. Please try again.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFEF911E),
                            ),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _onUpdateQuantity(Item item, int quantity, bool isAdd) {
    final inventoryModel = Provider.of<InventoryModel>(context, listen: false);
    final productCatalogModel = Provider.of<ProductCatalogModel>(context, listen: false);
    final success = inventoryModel.updateItemQuantity(item, quantity, isAdd);
    if (success && !isAdd) { // if quantity is being reduced, force reduce quantity of equivalent item in catalog
      productCatalogModel.copyItemQuantity(item);
    }
    if (!success && !isAdd) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Invalid Quantity'),
            content: const Text(
              'The requested quantity to remove is not valid.',
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFEF911E),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
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
            backgroundColor: const Color(0xFF1AB428),
            elevation: 1,
            heroTag: 'addButton',
            tooltip: 'Add an item',
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
      body: Center(
        child: Consumer<InventoryModel>(
            builder: (context, inventoryModel, child) {
            return inventoryModel.inventoryItems.isEmpty
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
                                  style: const TextStyle(
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
                        underline: const SizedBox(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ],
                  ),
                ),
                if(_isSearchFieldVisible)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
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
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearSearchField,
                          color: const Color(0xFFEF911E),
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
                      thumbVisibility: true,
                      thickness: 3,
                      interactive: true,
                      child: ValueListenableBuilder<LinkedHashSet<Item>>(
                          valueListenable: inventoryNotifier,
                          builder: (context, inventory, child) {
                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: inventory.length + 1,
                              itemBuilder: (context, index) {
                                if (index == inventory.length) {
                                  return Container(height: kFloatingActionButtonMargin + 120);
                                }
                                final item = inventory.elementAt(index);
                                return ItemTile(
                                  item: item,
                                  onItemEdit: _onItemEdit,
                                  onItemDelete: _onItemDelete,
                                  onQuantityChanged: _onUpdateQuantity,
                                );
                              },
                            );
                          }
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}