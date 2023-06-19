import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:provider/provider.dart';
import 'package:bizbuddyproject/ui/main_pages/all_main_pages.dart';
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

  ScaffoldMessengerState? _scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessenger = ScaffoldMessenger.of(context);
  }

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
    print('Inventory Notifier =============================');
    for (final item in Provider.of<InventoryModel>(context, listen: false).inventoryItems) {
      print(item);
    }
    print('================================');
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
        sortedItems = (Provider.of<InventoryModel>(context, listen: false).inventoryItems.toList()).reversed.toList();
      } else {
        sortedItems = Provider.of<InventoryModel>(context, listen: false).inventoryItems.toList();
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
            callingPage: widget.runtimeType,
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
          callingPage: widget.runtimeType,
        ),
      ),
    );
  }

  void _onItemDelete(Item item) {
    final cartModel = Provider.of<CartModel>(context, listen: false);
    final productCatalogModel = Provider.of<ProductCatalogModel>(context, listen: false);
    final inventoryModel = Provider.of<InventoryModel>(context, listen: false);
    final prodDup = item.duplicate();
    final cartDup = item.duplicate();
    // for undoing
    bool hasItemPC = productCatalogModel.productCatalog.any((i) => i.name == item.name);
    if(hasItemPC) {
      prodDup.quantity = productCatalogModel.productCatalog.firstWhere((i) => i.name == item.name).quantity;
    }
    bool hasItemCart = cartModel.cartItems.any((i) => i.name == item.name);
    if(hasItemCart) {
      cartDup.quantity = cartModel.cartItems.firstWhere((i) => i.name == item.name).quantity;
    }
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                Navigator.of(dialogContext).pop();
                if (cartModel.cartItems.any((i) => i.name == item.name) || productCatalogModel.productCatalog.any((i) => i.name == item.name)) {
                  showDialog(
                    barrierDismissible: true,
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text('Item in Product Catalog'),
                        content: const Text('A product with the same name exists in your catalog. Would you like to delete it from the catalog as well?'),
                        actions: [
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                inventoryModel.removeItem(item);
                                productCatalogModel.removeItem(item);
                                cartModel.removeItem(item);
                                _scaffoldMessenger?.hideCurrentSnackBar();
                                _scaffoldMessenger?.showSnackBar(
                                  SnackBar(
                                    content: const Text('Item deleted from all pages'),
                                    backgroundColor: const Color(0xFF616161),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 6.0,
                                    margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                    behavior: SnackBarBehavior.floating,
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      textColor: const Color(0xFFEF911E),
                                      onPressed: () {
                                        inventoryModel.addItem(item);
                                        productCatalogModel.addItem(prodDup);
                                        cartModel.addItem(cartDup);
                                      },
                                    ),
                                  ),
                                );
                                Navigator.of(context).pop();
                                // try {
                                //   setState(() {
                                //     Provider.of<InventoryModel>(context, listen: false).removeItem(item);
                                //     productCatalogModel.removeItem(item);
                                //     cartModel.removeItem(item);
                                //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //       SnackBar(
                                //         content: const Text('Item deleted from all pages'),
                                //         backgroundColor: const Color(0xFF616161),
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.circular(10.0),
                                //         ),
                                //         elevation: 6.0,
                                //         margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                //         behavior: SnackBarBehavior.floating,
                                //       ),
                                //     );
                                //   });
                                //   Navigator.of(dialogContext).pop();
                                // } catch (e) {
                                //   // display a dialog indicating the error
                                //   showDialog(
                                //     context: context,
                                //     builder: (BuildContext errorDialogContext) {
                                //       return AlertDialog(
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius: BorderRadius.circular(20),
                                //         ),
                                //         contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                //         title: const Text('Error'),
                                //         content:
                                //         const Text('An error occurred while deleting the item. Please try again.'),
                                //         actions: [
                                //           TextButton(
                                //             onPressed: () {
                                //               Navigator.of(context).pop();
                                //             },
                                //             style: TextButton.styleFrom(
                                //               foregroundColor: const Color(0xFFEF911E),
                                //             ),
                                //             child: const Text('OK'),
                                //           ),
                                //         ],
                                //       );
                                //     },
                                //   );
                                // }
                              });
                            },
                            child: const Text('Delete from Catalog'),
                          ),
                        ],
                      ),
                  ).then((value) {
                    setState(() {});
                  });
                } else {
                  setState(() {
                    Provider.of<InventoryModel>(context, listen: false).removeItem(item);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Item deleted from inventory'),
                        backgroundColor: const Color(0xFF616161),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 6.0,
                        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                        behavior: SnackBarBehavior.floating,
                        action: SnackBarAction(
                          label: 'Undo',
                          textColor: const Color(0xFFEF911E),
                          onPressed: () {
                            Provider.of<InventoryModel>(context, listen: false).addItem(item);
                          },
                        ),
                      ),
                    );
                  });
                  // try {
                  //   setState(() {
                  //     Provider.of<InventoryModel>(context, listen: false).removeItem(item);
                  //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(
                  //         content: const Text('Item deleted'),
                  //         backgroundColor: const Color(0xFF616161),
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10.0),
                  //         ),
                  //         elevation: 6.0,
                  //         margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  //         behavior: SnackBarBehavior.floating,
                  //       ),
                  //     );
                  //   });
                  // } catch (e) {
                  //   // display a dialog indicating the error
                  //   showDialog(
                  //     context: context,
                  //     builder: (BuildContext errorDialogContext) {
                  //       return AlertDialog(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(20),
                  //         ),
                  //         title: const Text('Error'),
                  //         content:
                  //         const Text('An error occurred while deleting the item. Please try again.'),
                  //         actions: [
                  //           TextButton(
                  //             child: const Text('OK'),
                  //             onPressed: () {
                  //               Navigator.of(errorDialogContext).pop();
                  //             },
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   );
                  // }
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    ).then((value) {
      setState(() {});
    });
  }

  void _onUpdateQuantity(Item item, int quantity, bool isAdd) {
    final inventoryModel = Provider.of<InventoryModel>(context, listen: false);
    final productCatalogModel = Provider.of<ProductCatalogModel>(context, listen: false);
    final success = inventoryModel.updateItemQuantity(item, quantity, isAdd);
    if (success && !isAdd) { // if quantity is being reduced, force reduce quantity of equivalent item in catalog
      productCatalogModel.copyItemQuantity(item);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Item updated'),
          backgroundColor: const Color(0xFF616161),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 6.0,
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        ),
      );
    }
    if (!success && !isAdd) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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

  void _onMoveToProductCatalog(Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemPage(
          item: item,
          callingPage: ProductCatalogPage,
          isAddingToCatalog: true,
        ),
      ),
    );
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
                                  onQuantityChanged: _onUpdateQuantity, onMoveToProductCatalog: _onMoveToProductCatalog,
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