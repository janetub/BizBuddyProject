import 'package:flutter/material.dart';
import '../../classes/all.dart';

class ProductTile extends StatelessWidget {
  final Item item;
  final void Function(Item) onProductEdit;
  final void Function(Item) onProductDelete;
  final void Function(Item) onAddToCart;

  const ProductTile({
    Key? key,
    required this.item,
    required this.onProductEdit,
    required this.onProductDelete,
    required this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.name),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {
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
          onProductDelete(item);
        }
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        child: ListTile(
          onTap: () => onProductEdit(item),
          title: Text(item.name),
          subtitle: Text(item.description),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () => onAddToCart(item),
          ),
        ),
      ),
    );
  }
}