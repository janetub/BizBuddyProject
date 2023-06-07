import 'dart:collection';

import 'package:flutter/material.dart';
import '../components/cart_detail_dialog.dart';
import '../components/product_tile.dart';
import '../input_forms/add_item.dart';
import '../../classes/all.dart';
import '../input_forms/edit_item.dart';

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
  final ValueChanged<Order> onPlaceOrder;
  final ValueChanged<VoidCallback> onSearchButtonPressed;

  ProductCatalogPage({
    Key? key,
    required this.productCatalog,
    required this.cartItems,
    required this.navigateToOrderStatus,
    required this.onPlaceOrder,
    required this.onSearchButtonPressed,
  }) : super(key: key);

  @override
  _ProductCatalogPageState createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {

  final TextEditingController _searchController = TextEditingController();
  LinkedHashSet<Item> _displayedItems = LinkedHashSet<Item>();
  final ScrollController _scrollController = ScrollController();
  bool _isSearchFieldVisible = false;
  var defaultCatalogSort = {};

  // TODO: for debugging, remove later
  @override
  void initState() {
    super.initState();
    widget.onSearchButtonPressed(_searchButtonPressed);
    for (int i = 1; i <= 15; i++) {
      Item item = Item('Item $i', 'Description for Item $i');
      item.cost = i * 10;
      item.markup = i * 5;
      item.quantity = 100 - (i * 5);
      if(i%2==0) {
        item.description = 'The quick brown fox jumps over the lazy dog. The dog found this entertaining and the fox laughs at the dog\'s reaction. The dog realizing this also laughs at himself. After awhile, both became friends.';
        item.tags.add('Lorem');
        item.tags.add('Ipsum');
        item.tags.add('Solem');
        item.tags.add('Lorem');
        item.tags.add('Jollibee');
        item.tags.add('Bida');
        item.tags.add('and');
        item.tags.add('saya');
        item.tags.add('Door');
        item.tags.add('Lorem');
        item.tags.add('Ipsum');
        item.tags.add('Solem');
        item.tags.add('Lorem');
        item.tags.add('Animal');
        item.tags.add('Door');
        item.tags.add('Slippers');
        item.addComponent(Item('Mop',''));
        item.addComponent(Item('Tulip',''));
        item.addComponent(Item('Mop',''));
        item.addComponent(Item('Cat',''));
        item.addComponent(Item('Roof',''));
        item.addComponent(Item('Mop',''));
        item.addComponent(Item('Tulip',''));
        item.addComponent(Item('Mop',''));
        item.addComponent(Item('Cat',''));
        item.addComponent(Item('Roof',''));
      }
      widget.productCatalog.add(item);
    }
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

  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (context) => CartDialog(
        cartItems: widget.cartItems,
        onClose: () => Navigator.pop(context),
        onPlaceOrder: _onPlaceOrder,
        onUpdateQuantity: _onUpdateQuantity,
      ),
    );
  }

  void _onPlaceOrder() {
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
              child: const Text('OK'),
              style: TextButton.styleFrom(
                primary: Color(0xFFEF911E),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      // Filter out items with zero quantity
      final nonZeroItems = LinkedHashSet<Item>.from(
          widget.cartItems.where((item) => item.quantity > 0));
      // Create order with non-zero quantity items
      Order order = Order(
          items: nonZeroItems,
        customers: [],
      );
      widget.onPlaceOrder(order);
      _showSuccessDialog(order);
      widget.cartItems.clear();
    }
  }

  void _showSuccessDialog(Order order) {
    setState(() {
    });
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return GestureDetector(
          onTap: () {
            Navigator.of(dialogContext).pop();
            Navigator.of(dialogContext).pop();
          },
          child: AlertDialog(
            title: const Text('Success'),
            content: const Text(
                'The item has been added and moved to the Order Status page for processing.'),
            actions: [
              TextButton(
                child: const Text('Ok'),
                style: TextButton.styleFrom(
                  primary: Colors.grey,
                ),
                onPressed: () {
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
                  Navigator.of(dialogContext).pop();
                  widget.navigateToOrderStatus();
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddItemPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddItemPage(
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
            });
          },
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
          onSubmit: (editedItem) {
            setState(() {
              // Update the item in the product catalog
              widget.productCatalog.remove(item);
              widget.productCatalog.add(editedItem);
            });
          },
        ),
      ),
    );
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