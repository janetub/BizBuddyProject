import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/all_components.dart';
import '../../classes/all_classes.dart';
import '../input_forms/all_input_forms.dart';
import '../../models/all_models.dart';

/*
* FIXME: do not move the order to order status page if quantity of orders is zero or do not include items with zero quantity
*  TODO: updates in product details in product catalog, inform user to remove item from cart
* */

class ProductCatalogPage extends StatefulWidget {
  final ValueNotifier<bool> searchButtonPressed;
    final VoidCallback navigateToOrderStatus;
    final Function(Order) onMoveOrder;

  const ProductCatalogPage({
    Key? key,
    required this.navigateToOrderStatus,
    required this.onMoveOrder,
    required this.searchButtonPressed,
  }) : super(key: key);

  @override
  State<ProductCatalogPage> createState() {
    return _ProductCatalogPageState();
  }
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {

  final TextEditingController _searchController = TextEditingController();
  final productCatalogNotifier = ValueNotifier<LinkedHashSet<Item>>(
    LinkedHashSet<Item>(),
  );
  final ScrollController _scrollController = ScrollController();
  bool _isSearchFieldVisible = false;
  String _selectedSortOption = 'Default';
  final List<String> _sortOptions = ['Default', 'Name', 'Price', 'Date added', 'Stocks'];
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
    final productCatalogData = Provider.of<ProductCatalogModel>(context, listen: false).productCatalog;
    productCatalogNotifier.value = productCatalogData;
    print('Prod Cat setState____________');
    for (final item in Provider.of<ProductCatalogModel>(context, listen: false).productCatalogItemBox) {
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
    final productCatalogModel = Provider.of<ProductCatalogModel>(context, listen: false).productCatalog;
    return LinkedHashSet<Item>.from(productCatalogModel.where((item) {
      final nameMatch = item.name.toLowerCase().contains(query.toLowerCase());
      final tagMatch = item.tags.any(
              (tag) => tag.toLowerCase().contains(query.toLowerCase()));
      return nameMatch || tagMatch;
    }));
  }

  void _performSearch(String query) {
    setState(() {
      productCatalogNotifier.value = searchItems(query);
    });
  }

  void _clearSearchField() {
    setState(() {
      _searchController.clear();
      productCatalogNotifier.value = Provider.of<ProductCatalogModel>(context, listen: false).productCatalog;
    });
  }

  LinkedHashSet<Item> sortItems(String sortOption, bool isAscending) {
    List<Item> sortedItems = productCatalogNotifier.value.toList();
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
      productCatalogNotifier.value = sortItems(sortOption, isAscending);
    });
  }

  // TODO: cancel order
  // remains in cart if not placed
  void _onOrderCancel(LinkedHashSet<Item> items) {
    // for (Item item in items) {
    //   bool itemFound = widget.productCatalog.any((i) => i.name == item.name);
    //   if (itemFound) {
    //     Item foundItem = widget.productCatalog.firstWhere((i) => i.name == item.name);
    //     foundItem.quantity += item.quantity;
    //   } else {
    //     widget.productCatalog.add(item);
    //   }
    // }
  }

  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (context) => CartDialog(
        onCheckoutOrder: _onCheckoutOrder,
      ),
    );
  }

  void _onCheckoutOrder() {
    // Check if all items have zero quantity
    if (Provider.of<CartModel>(context, listen: false).cartItems.every((item) => item.quantity == 0)) {
      // Show dialog to notify user that their cart is empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Empty Cart'),
          content: const Text('All items in your cart have zero quantity.'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFEF911E),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      // Filter out items with zero quantity
      final nonZeroItems = LinkedHashSet<Item>.from(
          Provider.of<CartModel>(context, listen: false).cartItems.where((item) => item.quantity > 0));
      // Show AddOrderPage to allow user to customize order details
      showDialog(
        context: context,
        builder: (context) => AddOrderPage(
          onPlaceOrder: (order) {
            _showSuccessDialog(order);
          },
          items: nonZeroItems,
          onOrderCancel: _onOrderCancel,
        ),
      );
    }
  }

  void _showSuccessDialog(Order order) {
    final cartModel = Provider.of<CartModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Press any button to continue'),
          content: const Text(
            'The item will be added and moved to the Order Status page for processing.',
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              onPressed: () {
                Order orderToMove = order;
                widget.onMoveOrder(orderToMove);
                cartModel.clear();
                setState(() {
                });
                Navigator.of(dialogContext).pop();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Ok'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFEF911E),
              ),
              onPressed: () {
                Order orderToMove = order;
                widget.onMoveOrder(orderToMove);
                cartModel.clear();
                setState(() {
                });
                widget.navigateToOrderStatus();
                Navigator.of(dialogContext).pop();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Go to Order Status'),
            ),
          ],
        );
      },
    );
  }

  void _showAddProductPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddItemPage(
            callingPage: widget,
          ),
        )
    );

  }

  void _onProductEdit(Item item) {
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

  void _onProductDelete(Item item) {
    final cartModel = Provider.of<CartModel>(context, listen: false);
    final productCatalogModel = Provider.of<ProductCatalogModel>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
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
                // Check if an item with the same name exists in the cart
                if (cartModel.cartItems.any((existingItem) => existingItem.name == item.name)) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Item in Cart'),
                      content: const Text('An item with the same name exists in the cart.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(dialogContext).pop();
                            });
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  try {
                    setState(() {
                      productCatalogModel.removeItem(item);
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
                          const Text('An error occurred while deleting the item. Please try again.'),
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
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _addToCart(Item item, int quantity) {
    final cartModel = Provider.of<CartModel>(context, listen: false);
    if(quantity>0) {
      bool containsItem = cartModel.cartItems.any((cartItem) => cartItem.name == item.name);
      if (containsItem) {
        // product already exists in cart
        if (item.quantity >= quantity) {
          setState(() {
            Item cartItem = cartModel.cartItems.firstWhere((cartItem) => cartItem.name == item.name);
            cartItem.quantity += quantity;
            item.quantity -= quantity;
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Insufficient Stock'),
                content: const Text('The requested quantity is not available.'),
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
      } else {
        // new product in cart
        if (item.quantity >= quantity) {
          setState(() {
            Item movProd = item.duplicate();
            movProd.quantity = quantity;
            cartModel.addItem(movProd);
            item.quantity -= quantity;
          });
        } else {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Insufficient Stock'),
                content: const Text('The requested quantity is not available.'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEDF1),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Consumer<CartModel>(
              builder: (context, cartModel, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: _showCartDialog,
                    backgroundColor: const Color(0xFFEF911E),
                    elevation: 1,
                    heroTag: 'cartButton',
                    tooltip: 'Check out cart',
                    child: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  if (Provider.of<CartModel>(context, listen: false).cartItems.isNotEmpty)
                    Positioned(
                      right: 1,
                      top: 1,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Text(
                          Provider.of<CartModel>(context, listen: false).cartItems.length > 99 ? '99+' : '${Provider.of<CartModel>(context, listen: false).cartItems.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            }
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _showAddProductPage,
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
      body: Consumer<ProductCatalogModel>(
          builder: (context, productCatalogModel, child) {
          return Center(
            child: productCatalogModel.productCatalog.isEmpty
                ? const Text(
              'Ready to sell?\nStart adding products!',
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
                        valueListenable: productCatalogNotifier,
                        builder: (context, productCatalog, child) {
                          // print('BUILD! ${productCatalogNotifier.value}');
                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: productCatalog.length + 1,
                            itemBuilder: (context, index) {
                              if (index == productCatalog.length) {
                                return Container(height: kFloatingActionButtonMargin + 120);
                              }
                              final item = productCatalog.elementAt(index);
                              return ProductTile(
                                item: item,
                                onProductEdit: _onProductEdit,
                                onProductDelete: _onProductDelete,
                                onAddToCart: _addToCart,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}