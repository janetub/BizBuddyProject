import 'package:flutter/material.dart';
import '../../classes/all.dart';


class OrderDetailsDialog extends StatelessWidget {
  final Order order;
  final ScrollController controller = ScrollController();

  OrderDetailsDialog({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Order Details',
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
                      'Order ID: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${order.orderId}',
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
                      'Date Placed: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${order.datePlaced.toLocal().toString().split(' ')[0]}',
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
                      'Delivery method: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        order.deliveryMethod,
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
                      'Current Status: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          try {
                            return Text(
                              order.getCurrentStatus()!.description == '' ? order.getCurrentStatus()!.label : '${order
                                  .getCurrentStatus()!.label} (${order
                                  .getCurrentStatus()!.description})' ,
                              style: TextStyle(fontSize: 18),
                            );
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("No Status"),
                                  content: Text("Please assign a current status to the order."),
                                  actions: [
                                    TextButton(
                                      child: Text("OK"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            return Text(
                              'No Status',
                              style: TextStyle(fontSize: 18),
                            );
                          }
                        },
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
                        '${order.calculateOrderTotalValue().toStringAsFixed(2)}',
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
                      'Profit: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${(order.calculateTotalPrice()-order.calculateTotalCost()).toStringAsFixed(2)}',
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
                      'Description: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        order.description,
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
                      'Items: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    Wrap(
                      spacing: 4,
                      children: order.items
                          .map(
                            (item) => Chip(
                          label: Text(
                            '(${item.quantity}) ${item.name}',
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
                      'Recipient:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        order.recipient.name,
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
                      order.recipient.contacts[order.deliveryMethod]!.length > 1 ? 'Contacts:' : 'Contact:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Wrap(
                      spacing: 4,
                      children: order.recipient.contacts.entries
                          .expand((entry) => entry.value.map((contact) => Chip(
                        label: Text(
                          '+$contact',
                          style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                          ),
                        ),
                        backgroundColor: Color(0xFF1AB428),
                      )))
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(primary: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
