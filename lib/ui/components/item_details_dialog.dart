import 'package:flutter/material.dart';
import '../../classes/all.dart';

class ItemDetailsDialog extends StatelessWidget {
  final Item item;
  final ScrollController controller = ScrollController();

  ItemDetailsDialog({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Item Details',
        style: TextStyle(fontSize: 24),
        textAlign: TextAlign.center,
      ),
      backgroundColor: const Color(0xFFEEEDF1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Scrollbar(
        isAlwaysShown: true,
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
                    Text(
                      'Name: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 4,),
                    Expanded(
                      child: Text(
                        '${item.name}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Desc.: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 4,),
                    Expanded(
                      child: Text(
                        '${item.description}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cost: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 30,),
                    Expanded(
                      child: Text(
                        '${item.cost.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Markup: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 6,),
                    Expanded(
                      child: Text(
                        '${(item.price - item.cost).toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 26,),
                    Expanded(
                      child: Text(
                        '${item.price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quantity: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 0,),
                    Expanded(
                      child: Text(
                        '${item.quantity}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tags: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 4,),
                    Expanded(
                      child: Wrap(
                        spacing: 5,
                        alignment: WrapAlignment.start,
                        children: item.tags.map((tag) =>
                            Text(
                              '#$tag',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            )
                        ).toList(),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.calculateTotalPriceValue().toStringAsFixed(2),
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date Added: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 4,),
                    Expanded(
                      child: Text(
                        '${item.dateAdded?.toLocal().toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: Colors.black12,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
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
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                          ),
                          labelPadding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                          backgroundColor: Color(0xFFEF911E),
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
          TextButton.styleFrom(primary:
          Colors.grey,),
          onPressed:
              () => Navigator.of(context).pop(),
          child:
          const Text('Close'),
        ),
      ],
    );
  }
}