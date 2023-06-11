import 'package:bizbuddyproject/ui/components/order_details_dialog.dart';
import 'package:flutter/material.dart';
import '../../classes/all.dart';

/*
* TODO: order phase details and other order details
* */

class OrderTile extends StatefulWidget {
  final Order order;
  final void Function(Order) onOrderCancel;
  final void Function(Order) onProductEdit;

  const OrderTile({
    Key? key,
    required this.order,
    required this.onOrderCancel,
    required this.onProductEdit
  }) : super(key: key);

  @override
  _OrderTileState createState() => _OrderTileState();
}


class _OrderTileState extends State<OrderTile> {

  Future<void> _onEditStatusButton(OrderStatus orderStatus) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController labelController = TextEditingController(text: orderStatus.label);
    final TextEditingController descriptionController = TextEditingController(text: orderStatus.description);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit order status',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,),
          backgroundColor: const  Color(0xFFF9F9F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    cursorColor: Color(0xFFEF911E),
                    controller: labelController,
                    decoration: InputDecoration(
                      labelText: 'Label',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value==null || value.isEmpty || value=='') {
                        return 'Field cannot be left blank';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    cursorColor: Color(0xFFEF911E),
                    maxLines: null,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                  Navigator.of(context).pop({
                    'label': labelController.text,
                    'description': descriptionController.text,
                  });
                }
              },
              child: Text('OK',
                style: TextStyle(color: Color(0xFFEF911E)),
              ),
            ),
          ],
        );
      },
    );
    if (result != null) {
      final label = result['label'];
      final description = result['description'];
      if (label != null && description != null) {
        setState(() {
          orderStatus.label = label;
          orderStatus.description = description;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            widget.onProductEdit(widget.order);
            return Future.value(false);
          }
          return Future.value(true);
        },
        background: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.green,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Icon(Icons.edit),
              ),
            ),
          ),
        ),
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
                      Text('${widget.order.orderId} - ${widget.order.deliveryMethod}\n${widget.order.recipient.name}: ${(widget.order.recipient.contacts[widget.order.deliveryMethod]!).join('; ')}',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // trailing: Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     // TODO: interactive buttons in the right
                      //     IconButton(onPressed: (){}, icon: Icon(Icons.edit_attributes),
                      //     color: Color(0xFFEF911E),)
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
                          onLongPress: () => _onEditStatusButton(widget.order.statuses.elementAt(index)),
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