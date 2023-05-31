import 'package:flutter/material.dart';
import '../components/cart_dialog.dart';
import '../components/product_tile.dart';
import '../input_forms/add_item.dart';
import '../../classes/all.dart';
import '../input_forms/edit_item.dart';
import 'order_status.dart';

class ProductCatalogPage extends StatefulWidget {
  final Set<Item> productCatalog;
  final VoidCallback navigateToOrderStatus;
  final ValueChanged<Order> onPlaceOrder;

  ProductCatalogPage({
    Key? key,
    required this.productCatalog,
    required this.navigateToOrderStatus,
    required this.onPlaceOrder,
  }) : super(key: key);

  @override
  _ProductCatalogPageState createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  Set<Item> _productCatalog = Set<Item>();
  List<Item> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _productCatalog = widget.productCatalog;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _showCartDialog,
            backgroundColor: Colors.grey[400],
            elevation: 1,
            child: const Icon(
              Icons.shopping_cart,
              color: Colors.black87,
              size: 30,
            ),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _showAddItemPage,
            backgroundColor: Colors.grey[400],
            elevation: 1,
            child: const Icon(
              Icons.add,
              color: Colors.black87,
              size: 30,
            ),
          ),
        ],
      ),
      body: Center(
        child: _productCatalog.isEmpty
            ? const Text(
          'Ready to sell?\nStart adding products!',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        )
            : ListView.builder(
          itemCount: _productCatalog.length,
          itemBuilder: (context, index) {
            final item = _productCatalog.toList()[index];
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

  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CartDialog(
          cartItems: _cartItems,
          onClose: () {
            Navigator.of(dialogContext).pop();
          },
          onPlaceOrder: () {
            _onPlaceOrderButtonPressed();
          },
        );
      },
    );
  }


  void _showSuccessDialog(Order order) {
    _onPlaceOrderButtonPressed();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text(
              'The item has been added to moved to the Order Status page for processing.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Go to Order Status'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                widget.navigateToOrderStatus();
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
            _productCatalog.add(item);
          });
        },
      ),
    );
  }

  void _addToCart(Item item) {
    if (item.quantity > 0) {
      setState(() {
        _cartItems.add(item);
        item.removeQuantity(1); // Decrease the quantity of the added item
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Out of Stock'),
            content: const Text('This item is currently out of stock.'),
            actions: [
              TextButton(
                child: const Text('OK'),
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


  void _onPlaceOrderButtonPressed() {
    Order order = Order(items: _cartItems);
    widget.onPlaceOrder(order);
    _showSuccessDialog(order);
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
              _productCatalog.remove(item);
              _productCatalog.add(editedItem);
            });
          },
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
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  _productCatalog.remove(item);
                });
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}