import 'package:flutter/material.dart';
import '../input_forms/add_item.dart';
import '../../classes/all.dart';

class ProductCatalogPage extends StatefulWidget {
  final Set<Item> productCatalog;

  ProductCatalogPage({Key? key, required this.productCatalog}) : super(key: key);

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
              },
              productCatalog: _productCatalog, // Pass the product catalog to the AddItemPage
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
            : Container(
          // TODO: display populated data
        ),
      ),
    );
  }
}