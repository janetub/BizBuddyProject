import 'dart:collection';

import 'package:bizbuddyproject/ui/input_forms/add_product.dart';
import 'package:flutter/material.dart';
import '../components/cart_dialog.dart';
import '../components/product_tile.dart';
import '../../classes/all.dart';
import '../input_forms/add_order.dart';
import '../input_forms/edit_product.dart';

/*
* FIXME: do not move the order to order status page if quantity of orders is zero or do not include items with zero quantity
*  TODO: updates in product details in product catalog, inform user to remove item from cart
*   TODO : arrange tiles
*  TODO: Add a recipient
* */

class ProductCatalogPage extends StatefulWidget {
  final LinkedHashSet<Item> productCatalog;
  final LinkedHashSet<Item> cartItems;
  final VoidCallback navigateToOrderStatus;
  final Function(Order) onMoveOrder;
  final ValueChanged<VoidCallback> onSearchButtonPressed;
  final Inventory inventory;

  ProductCatalogPage({
    Key? key,
    required this.productCatalog,
    required this.cartItems,
    required this.navigateToOrderStatus,
    required this.onMoveOrder,
    required this.onSearchButtonPressed,
    required this.inventory,
  }) : super(key: key);

  @override
  _ProductCatalogPageState createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {

  final TextEditingController _searchController = TextEditingController();
  LinkedHashSet<Item> _displayedItems = LinkedHashSet<Item>();
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

  // TODO: for debugging, remove later
  @override
  void initState() {
    super.initState();
    widget.onSearchButtonPressed(_searchButtonPressed);

    _displayedItems = widget.productCatalog;
  }

  void _searchButtonPressed() {
    setState(() {
      _isSearchFieldVisible = !_isSearchFieldVisible;
    });
  }

  LinkedHashSet<Item> searchItems(String query) {
    return LinkedHashSet<Item>.from(widget.productCatalog.where((item) {
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
      _displayedItems = widget.productCatalog;
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
    } else if (sortOption == 'Price') {
      sortedItems.sort((a, b) => isAscending ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
    } else if (sortOption == 'Date added') {
      sortedItems.sort((a, b) => isAscending ? a.dateAdded!.compareTo(b.dateAdded!) : b.dateAdded!.compareTo(a.dateAdded!));
    } else if (sortOption == 'Stocks') {
      sortedItems.sort((a, b) => isAscending ? a.quantity.compareTo(b.quantity) : b.quantity.compareTo(a.quantity));
    } else {
      if (!isAscending) {
        sortedItems = (widget.productCatalog.toList()).reversed.toList();
      } else {
        sortedItems = widget.productCatalog.toList();
      }
    }
    return LinkedHashSet.from(sortedItems);
  }

  void _performSort(String sortOption, bool isAscending) {
    setState(() {
      _displayedItems = sortItems(sortOption, isAscending);
    });
  }

  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (context) => CartDialog(
        cartItems: widget.cartItems,
        onCheckoutOrder: _onCheckoutOrder,
        onUpdateQuantity: _onUpdateQuantity,
      ),
    );
  }

  void _onCheckoutOrder() {
    // Check if all items have zero quantity
    if (widget.cartItems.every((item) => item.quantity == 0)) {
      // Show dialog to notify user that their cart is empty
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Empty Cart'),
          content: const Text('All items in your cart have zero quantity.'),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                primary: const Color(0xFFEF911E),
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
          widget.cartItems.where((item) => item.quantity > 0));
      // Show AddOrderPage to allow user to customize order details
      showDialog(
        context: context,
        builder: (context) => AddOrderPage(
          onPlaceOrder: (order) {
            _showSuccessDialog(order);
          },
          items: nonZeroItems,
        ),
      );
    }
  }

  void _showSuccessDialog(Order order) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Press any button to confirm'),
          content: const Text(
              'The item will be added and moved to the Order Status page for processing.',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            TextButton(
              child: const Text('Ok'),
              style: TextButton.styleFrom(
                primary: Colors.grey,
              ),
              onPressed: () {
                Order orderToMove = order;
                widget.onMoveOrder(orderToMove);
                //
                widget.cartItems.clear();
                setState(() {
                });
                Navigator.of(dialogContext).pop();
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Go to Order Status'),
              style: TextButton.styleFrom(
                primary: Color(0xFFEF911E),
              ),
              onPressed: () {
                Order orderToMove = order;
                widget.onMoveOrder(orderToMove);
                //
                widget.cartItems.clear();
                widget.navigateToOrderStatus();
                Navigator.of(dialogContext).pop();
                Navigator.of(dialogContext).pop();
              },
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
          builder: (context) => AddProductPage(
            onSubmit: (item) {
              setState(() {
                if (widget.productCatalog.any((existingItem) => existingItem.name == item.name)) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Duplicate Item'),
                      content: Text('An item with the same name already exists in the product catalog.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
                widget.productCatalog.add(item);
                //
              });
            }, inventory: widget.inventory,
          ),
        )
    );
  }

  void _onProductEdit(Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductPage(
          item: item,
          onSubmit: (editedItem) {
            setState(() {
              // Update the item in the product catalog
              widget.productCatalog.remove(item);
              widget.productCatalog.add(editedItem);
              //
            });
          }, inventory: widget.inventory,
        ),
      ),
    );
  }

  void _onProductDelete(Item item) {
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
                // Check if an item with the same name exists in the cart
                if (widget.cartItems.any((existingItem) => existingItem.name == item.name)) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Item in Cart'),
                      content: Text('An item with the same name exists in the cart.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.of(dialogContext).pop();
                            });
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                } else {
                  try {
                    setState(() {
                      widget.productCatalog.remove(item);
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
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _onUpdateQuantity(Item item, int quantity) {
    if (quantity > 0) {
      // removing quantity
      if (item.quantity >= quantity) {
        setState(() {
          item.quantity -= quantity;
          if(item.quantity == 0) {
            widget.cartItems.remove(item);
          }
          // update productCatalog
          bool containsItem = widget.productCatalog.any((cartItem) => cartItem.name == item.name);
          if(containsItem) {
            Item catalogItem = widget.productCatalog.firstWhere((cartItem) => cartItem.name == item.name);
            catalogItem.quantity += quantity;
          } else {
            Item newItem = item.duplicate();
            newItem.quantity = item.quantity;
            widget.productCatalog.add(newItem);
          }
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

  void _addToCart(Item item, int quantity) {
    if(quantity>0) {
      bool containsItem = widget.cartItems.any((cartItem) => cartItem.name == item.name);
      if (containsItem) {
        // product already exists in cart
        if (item.quantity >= quantity) {
          setState(() {
            Item cartItem = widget.cartItems.firstWhere((cartItem) => cartItem.name == item.name);
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
      } else {
        // new product in cart
        if (item.quantity >= quantity) {
          setState(() {
            Item movProd = item.duplicate();
            movProd.quantity = quantity;
            widget.cartItems.add(movProd);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEDF1),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              FloatingActionButton(
                onPressed: _showCartDialog,
                backgroundColor: Color(0xFFEF911E),
                elevation: 1,
                heroTag: 'cartButton',
                tooltip: 'Check out cart',
                child: const Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              if (widget.cartItems.length > 0)
                Positioned(
                  right: 1,
                  top: 1,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      widget.cartItems.length > 99 ? '99+' : '${widget.cartItems.length}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _showAddProductPage,
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
        child: widget.productCatalog.isEmpty
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
                      return ProductTile(
                        item: item,
                        onProductEdit: _onProductEdit,
                        onProductDelete: _onProductDelete,
                        onAddToCart: _addToCart,
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