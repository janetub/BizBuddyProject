import 'package:bizbuddyproject/ui/components/all_components.dart';
import 'package:flutter/material.dart';
import '../../../classes/all_classes.dart';

/*
* TODO: order phase details and other order details
* TODO: checkbutton for paid
* */

class OrderTile extends StatefulWidget {
  final Order order;
  final void Function(Order) onOrderCancel;
  final void Function(Order) onOrderEdit;

  const OrderTile({
    Key? key,
    required this.order,
    required this.onOrderCancel,
    required this.onOrderEdit,
  }) : super(key: key);

  @override
  State<OrderTile> createState() {
    return _OrderTileState();
  }
}


class _OrderTileState extends State<OrderTile> {

  Future<void> _onEditStatusButton(OrderStatus orderStatus) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController labelController = TextEditingController(text: orderStatus.label);
    final TextEditingController descriptionController = TextEditingController(text: orderStatus.description);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit order status',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,),
          backgroundColor: const  Color(0xFFF9F9F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    cursorColor: const Color(0xFFEF911E),
                    controller: labelController,
                    decoration: InputDecoration(
                      labelText: 'Label',
                      labelStyle: const TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value==null || value.isEmpty || value=='') {
                        return 'Field cannot be left blank';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    cursorColor: const Color(0xFFEF911E),
                    maxLines: null,
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: const TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
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
              child: const Text('Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState != null && formKey.currentState!.validate()) {
                  Navigator.of(context).pop({
                    'label': labelController.text,
                    'description': descriptionController.text,
                  });
                }
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Order status edited'),
                    backgroundColor: const Color(0xFF616161),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 6.0,
                    margin: const EdgeInsets.only(bottom: 10.0),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('OK',
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
            widget.onOrderEdit(widget.order);
            return Future.value(false);
          }
          return Future.value(true);
        },
        background: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.green,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Icon(Icons.edit),
              ),
            ),
          ),
        ),
        secondaryBackground: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: Colors.red,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(15),
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
              padding: const EdgeInsets.fromLTRB(0,0,0,0),
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
                            widget.order.datePlaced.toLocal().toString().split(' ')[0],
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text('Total: ${widget.order.calculateOrderTotalValue().toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      subtitle:
                      Text('${widget.order.orderId} - ${widget.order.deliveryMethod}\n${widget.order.recipient.name}: ${(widget.order.recipient.contacts[widget.order.deliveryMethod]!).join(', ')}',
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
                      contentPadding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
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
                            foregroundColor: isActive ? Colors.white : const Color(0xFF1AB428), backgroundColor: isActive ? const Color(0xFF1AB428) : Colors.white,
                            side: const BorderSide(
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