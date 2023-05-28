import 'package:flutter/material.dart';
import '../input_forms/add_item.dart';
import '../../classes/all.dart';
import 'order_status.dart';

class ProductCatalogPage extends StatefulWidget {
  final Set<Item> productCatalog;
  final Function navigateToOrderStatus;

  ProductCatalogPage({
    Key? key,
    required this.productCatalog,
    required this.navigateToOrderStatus,
  }) : super(key: key);

  @override
  _ProductCatalogPageState createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  Set<Item> _productCatalog = Set<Item>();

  @override
  void initState() {
    super.initState();
    _productCatalog = widget.productCatalog;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      floatingActionButton: FloatingActionButton(
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
                // Store the created Item object and update the UI
                setState(() {
                  _productCatalog.add(item); // Add the item to the product catalog
                });
              },// Pass the product catalog to the AddItemPage
            ),
          );
        },
        backgroundColor: Colors.grey[400],
        elevation: 100,
        child: const Icon(
          Icons.add,
          color: Colors.black87,
          size: 30,
        ),
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
            return Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(item.description),
                trailing: IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return AlertDialog(
                          title: const Text('Place Order'),
                          content: const Text('Are you sure you want to place this order?'),
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
                                Order order = Order(items: [item]);
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
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSuccessDialog(Order order) {
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
}