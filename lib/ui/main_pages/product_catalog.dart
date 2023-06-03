import 'package:flutter/material.dart';
import '../components/cart_dialog.dart';
import '../components/product_tile.dart';
import '../input_forms/add_item.dart';
import '../../classes/all.dart';
import '../input_forms/edit_item.dart';

/*
* FIXME: do not move the order to order status page if quantity of orders is zero or do not include items with zero quantity
* */

class ProductCatalogPage extends StatefulWidget {
  final Set<Item> productCatalog;
  final Set<Item> cartItems;
  final VoidCallback navigateToOrderStatus;
  final ValueChanged<Order> onPlaceOrder;

  ProductCatalogPage({
    Key? key,
    required this.productCatalog,
    required this.cartItems,
    required this.navigateToOrderStatus,
    required this.onPlaceOrder,
  }) : super(key: key);

  @override
  _ProductCatalogPageState createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEDF1),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _showCartDialog,
            backgroundColor: Color(0xFFEF911E),
            elevation: 1,
            child: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 30,
            ),
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
            : ListView.builder(
          itemCount: widget.productCatalog.length + 1,
          itemBuilder: (context, index) {
            if (index == widget.productCatalog.length) {
              return Container(height: kFloatingActionButtonMargin + 120);
            }
            final item = widget.productCatalog.elementAt(index);
            return ProductTile(
              item: item,
              onProductEdit: _onProductEdit,
              onProductDelete: _onProductDelete,
              onAddToCart: _addToCart,
            );
          },
        ),
      ),
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
      final nonZeroItems = widget.cartItems.where((item) => item.quantity > 0).toSet();
      // Create order with non-zero quantity items
      Order order = Order(items: nonZeroItems);
      widget.onPlaceOrder(order);
      _showSuccessDialog(order);
      widget.cartItems.clear();
    }
  }

  void _showSuccessDialog(Order order) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text(
              'The item has been added and moved to the Order Status page for processing.'),
          actions: [
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
        );
      },
    );
  }

  void _showAddItemPage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) => AddItemPage(
        onSubmit: (item) {
          setState(() {
            widget.productCatalog.add(item);
          });
        },
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
                primary: Color(0xFFEF911E),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  widget.productCatalog.remove(item);
                });
                Navigator.of(dialogContext).pop();
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
}