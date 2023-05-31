import 'package:flutter/material.dart';
import '../input_forms/add_item.dart';
import '../../classes/all.dart';
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
            onPressed: () {
              _showCartDialog();
            },
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
            onPressed: () {
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
            },
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
            return Dismissible(
              key: Key(item.name),
              confirmDismiss: (direction) {
                if (direction == DismissDirection.startToEnd){
                  return Future.value(false);
                }
                return Future.value(true);
              },
              background: Container(),
              secondaryBackground: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.delete),
                    ),
                  ),
                ),
              ),
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  _onProductDelete;
                }
              },
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
                child: ListTile(
                  onTap: () {
                    _onProductEdit;
                  },
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  trailing: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      _cartItems.add(item);
                    },
                  ),
                ),
              ),
            );
          },
        )
      ),
    );
  }

  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFE5E5E5),
              title: const Text('Cart'),
              content: _cartItems.isEmpty
                  ? const Text('Your cart is empty.')
                  : SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    final item = _cartItems[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(item.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _cartItems.add(item);
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  _cartItems.remove(item);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
                if (_cartItems.isNotEmpty)
                  TextButton(
                    child: const Text('Place Order'),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('Place Order'),
                            content:
                            const Text('Are you sure you want to place this order?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Confirm'),
                                onPressed: () {
                                  Order order = Order(items:_cartItems);
                                  Navigator.of(dialogContext).pop();
                                  _showSuccessDialog(order);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
              ],
            );
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

  void _onPlaceOrderButtonPressed() {
    Order order = Order(items:_cartItems);
    widget.onPlaceOrder(order);
  }
}

void _onProductEdit(Item item) {

}

void _onProductDelete(Item item) {

}