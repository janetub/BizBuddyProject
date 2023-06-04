import 'package:flutter/material.dart';
import '../../classes/all.dart';

class OrderTile extends StatefulWidget {
  final Order order;
  final void Function(Order) onOrderCancel;

  const OrderTile({
    Key? key,
    required this.order,
    required this.onOrderCancel
  }) : super(key: key);

  @override
  _OrderTileState createState() => _OrderTileState();
}


class _OrderTileState extends State<OrderTile> {
  @override
  Widget build(BuildContext context) {
    String customerNames = widget.order.customers
        .map((customer) => '${customer.firstName} ${customer.lastName}')
        .join(', ');
    return Dismissible(
      key: UniqueKey(),
      confirmDismiss: (direction) {
        if (direction == DismissDirection.startToEnd) {
          return Future.value(false);
        }
        return Future.value(true);
      },
      background: Container(),
      secondaryBackground: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Icon(Icons.delete),
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          widget.onOrderCancel(widget.order);
        }
      },
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
            padding: EdgeInsets.fromLTRB(5,10,0,10),
            child: Column(
              children: [
                ListTile(
                  onTap: () {} , // TODO : show order details
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.order.datePlaced.toLocal().toString().split(' ')[0]}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text('₱ ${widget.order.calculateOrderTotalValue().toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  subtitle:
                  Text('${widget.order.orderId}\n$customerNames'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // TODO: interactive buttons in the right
                    ],
                  ),
                  isThreeLine: true,
                  dense: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  onLongPress: () {},
                ),
              ],
            )
        ),
      ),
    );
  }
}