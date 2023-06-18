import 'package:flutter/material.dart';
import '../../../classes/all_classes.dart';

class ProductDetailsDialog extends StatelessWidget {
  final Item item;
  final ScrollController controller = ScrollController();

  ProductDetailsDialog({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Product Details',
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
      ),
      backgroundColor: const Color(0xFFEEEDF1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Scrollbar(
        thumbVisibility: true,
        thickness: 3.0,
        controller: controller,
        interactive: true,
        child: SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 4,),
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Desc.: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 4,),
                    Expanded(
                      child: Text(
                        item.description,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cost: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 30,),
                    Expanded(
                      child: Text(
                        item.cost.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Markup: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 6,),
                    Expanded(
                      child: Text(
                        (item.price - item.cost).toStringAsFixed(2),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 26,),
                    Expanded(
                      child: Text(
                        item.price.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quantity: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 0,),
                    Expanded(
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tags: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 4,),
                    Expanded(
                      child: Wrap(
                        spacing: 5,
                        alignment: WrapAlignment.start,
                        children: item.tags.map((tag) =>
                            Text(
                              '#$tag',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            )
                        ).toList(),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Price: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.calculateTotalPriceValue().toStringAsFixed(2),
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date Added: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 4,),
                    Expanded(
                      child: Text(
                        '${item.dateAdded?.toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Components: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Wrap(
                      spacing: 4,
                      children: item.components
                          .map(
                            (component) => Chip(
                          label: Text(
                            '(${component.quantity}) ${component.name}',
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          labelPadding: const EdgeInsets.fromLTRB(7, 0, 7, 0),
                          backgroundColor: const Color(0xFFEF911E),
                        ),
                      )
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions:[
        TextButton(
          style:
          TextButton.styleFrom(foregroundColor: Colors.grey,),
          onPressed:
              () => Navigator.of(context).pop(),
          child:
          const Text('Close'),
        ),
      ],
    );
  }
}