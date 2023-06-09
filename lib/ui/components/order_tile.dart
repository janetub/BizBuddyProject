import 'package:bizbuddyproject/ui/components/order_details_dialog.dart';
import 'package:flutter/material.dart';
import '../../classes/all.dart';

/*
* TODO: order phase details and other order details
* */

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
        .map((customer) => customer.name)
        .join(', ');
    return InkWell(
      highlightColor: Colors.green,
      splashColor: Colors.orange,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => OrderDetailsDialog(
            order: widget.order,
          ),
        );
      },
      child: Dismissible(
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
              padding: EdgeInsets.fromLTRB(0,0,0,0),
              child: Column(
                children: [
                  Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: ListTile(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => OrderDetailsDialog(
                            order: widget.order,
                          ),
                        );
                      },
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
                      Text('${widget.order.orderId}\n$customerNames',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // trailing: Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     // TODO: interactive buttons in the right
                      //   ],
                      // ),
                      isThreeLine: true,
                      dense: true,
                      contentPadding: EdgeInsets.fromLTRB(18, 10, 18, 0),
                      onLongPress: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: Wrap(
                      spacing: 5,
                      alignment: WrapAlignment.start,
                      children: widget.order.statuses.toList().asMap().entries.map((entry) {
                        int index = entry.key;
                        OrderStatus orderStatus = entry.value;
                        bool isActive = index == widget.order.currentStatusIndex;
                        return OutlinedButton(
                          onPressed: () {
                            setState(() {
                              widget.order.currentStatusIndex = index;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            primary: isActive ? Colors.white : Color(0xFF1AB428),
                            backgroundColor: isActive ? Color(0xFF1AB428) : Colors.white,
                            side: BorderSide(
                              color: Color(0xFFEF911E),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                          child: Text(orderStatus.label),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}