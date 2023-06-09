import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/all.dart';

/*
* TODO: Retain created group of buttons
* */

class AddOrderPage extends StatefulWidget {
  final Function(Order) onPlaceOrder;
  final LinkedHashSet<Item> items;

  AddOrderPage({
    required this.onPlaceOrder,
    required this.items,
  });

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends State<AddOrderPage> {
  final ScrollController controller = ScrollController();
  final _formKey = GlobalKey<FormState>();
  List<TextEditingController> _nameControllers = [TextEditingController()];
  List<TextEditingController> _contactsControllers = [TextEditingController()];
  final Map<String, LinkedHashSet<OrderStatus>> _premadeGroups = {
    'Default': LinkedHashSet.from([
      OrderStatus(label: 'Pending', description: ''),
      OrderStatus(label: 'Processing', description: ''),
      OrderStatus(label: 'Ready', description: ''),
      OrderStatus(label: 'Complete', description: ''),
      OrderStatus(label: 'On Hold', description: ''),
      OrderStatus(label: 'Canceled', description: ''),
    ]),
  };
  String _selectedPremadeGroup = 'Default';
  String _selectedDeliveryMethod = 'Pickup';

  void _addRecipient() {
    setState(() {
      _nameControllers.add(TextEditingController());
    });
  }

  void _removeRecipient(int index) {
    setState(() {
      _nameControllers.removeAt(index);
    });
  }

  void _addContact() {
    setState(() {
      _contactsControllers.add(TextEditingController());
    });
  }

  void _removeContact(int index) {
    setState(() {
      _contactsControllers.removeAt(index);
    });
  }

  LinkedHashSet<Person> _getRecipients() {
    return LinkedHashSet.from(
      _nameControllers.map((controller) => Person(controller.text)),
    );
  }

  Future<void> _onAddStatusButton() async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController labelController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add custom button',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,),
            backgroundColor: const  Color(0xFFF9F9F9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          content: Form(
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
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                  Navigator.of(context).pop({
                    'label': labelController.text,
                    'description': descriptionController.text,
                  });
                }
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
    if (result != null && _premadeGroups[_selectedPremadeGroup] != null) {
      final label = result['label'];
      final description = result['description'];
      if (label != null && description != null) {
        final orderStatus = OrderStatus(
          label: label,
          description: description,
        );
        setState(() {
          _premadeGroups[_selectedPremadeGroup]!.add(orderStatus);
        });
      }
    }
  }

  Future<void> _onEditCustomButton(OrderStatus orderStatus) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController labelController = TextEditingController(text: orderStatus.label);
    final TextEditingController descriptionController = TextEditingController(text: orderStatus.description);

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add custom button',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,),
          backgroundColor: const  Color(0xFFF9F9F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Form(
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
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                  Navigator.of(context).pop({
                    'label': labelController.text,
                    'description': descriptionController.text,
                  });
                }
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
    if (result != null && _premadeGroups[_selectedPremadeGroup] != null) {
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

  Future<void> _onAddGroupStatusButton() async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController labelController = TextEditingController();

    final result_groupname = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add new order status group',
            style: TextStyle(fontSize: 24),
            textAlign: TextAlign.center,),
          backgroundColor: const  Color(0xFFF9F9F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  cursorColor: Color(0xFFEF911E),
                  controller: labelController,
                  decoration: InputDecoration(
                    labelText: 'Status group name',
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  Navigator.of(context).pop(labelController.text);
                }
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
    if (result_groupname != null) {
      final name = result_groupname;
      if (name != null) {
        setState(() {
          _premadeGroups[name] = LinkedHashSet<OrderStatus>();
          _premadeGroups[name]!.add(OrderStatus(label: 'Pending', description: ''));
          _selectedPremadeGroup = name;
        });
      }
    }
  }

  void _onRemoveSelectedGroup() {
    if (_selectedPremadeGroup != 'Default') {
      setState(() {
        _premadeGroups.remove(_selectedPremadeGroup);
        _selectedPremadeGroup = 'Default';
      });
    }
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onReset() {
    setState(() {
      for (final controller in _nameControllers) {
        controller.clear();
      }
      for (final controller in _contactsControllers) {
        controller.clear();
      }
      _premadeGroups.clear();
      _premadeGroups['Default'] = LinkedHashSet.from([
        OrderStatus(label: 'Pending', description: ''),
        OrderStatus(label: 'Processing', description: ''),
        OrderStatus(label: 'Ready', description: ''),
        OrderStatus(label: 'Complete', description: ''),
        OrderStatus(label: 'On Hold', description: ''),
        OrderStatus(label: 'Canceled', description: ''),
      ]);
      _selectedPremadeGroup = 'Default';
      _selectedDeliveryMethod = 'Pickup';
      _nameControllers.clear();
      _nameControllers.add(TextEditingController());
      _contactsControllers.clear();
      _contactsControllers.add(TextEditingController());
    });
  }

  void _onPlaceOrder() {
    if (_nameControllers.length > 1) {
      for (int i = _nameControllers.length - 1; i >= 0; i--) {
        if (_nameControllers[i].text.isEmpty) {
          _removeRecipient(i);
        }
      }
    }
    if (_contactsControllers.length > 1) {
      for (int i = _contactsControllers.length - 1; i >= 0; i--) {
        if (_contactsControllers[i].text.isEmpty) {
          _removeContact(i);
        }
      }
    }
    if(_formKey.currentState!.validate()) {
      try{
        List<Person> customers = [];
        for (int i = 0; i < _nameControllers.length; i++) {
          String name = _nameControllers[i].text;
          String contact = _contactsControllers[i].text;
          Person person = Person(name);
          person.addContact(_selectedDeliveryMethod, contact);
          customers.add(person);
        }
        final placedOrder = Order(
            items: widget.items,
            customers: LinkedHashSet.from(customers),);
        placedOrder.statuses.addAll(_premadeGroups[_selectedPremadeGroup] as Iterable<OrderStatus>);
        placedOrder.datePlaced = DateTime.now();
        widget.onPlaceOrder(placedOrder);
        Navigator.pop(context);
        print("order info window should close");
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invalid entries:\n'),
            content: Text('$e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF808080), Color(0xFF808080)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                backgroundColor: Colors.transparent,
                title: Text('Customise Order Information'),
                elevation: 0,
                floating: true,
                snap: true,
              ),
              SliverToBoxAdapter(
                child: Card(
                  margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  color: Color(0xFFF9F9F9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [..._nameControllers
                            .asMap()
                            .entries
                            .map((entry) {
                          int index = entry.key;
                          TextEditingController controller = entry.value;
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == _nameControllers.length - 1 ? 0.0 : 16.0,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    cursorColor: Color(0xFFEF911E),
                                    controller: controller,
                                    decoration: InputDecoration(
                                      labelText: 'Customer/Recipient Name',
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
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter at least one recipient';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                if (_nameControllers.length > 1)
                                  IconButton(
                                    padding: EdgeInsets.all(0),
                                    constraints: BoxConstraints.tight(Size(24, 24)),
                                    onPressed: () => _removeRecipient(index),
                                    icon: Icon(Icons.close, color: Color(0xFFEF911E)),
                                  ),
                              ],
                            ),
                          );
                        }),
                          TextButton(
                            onPressed: _addRecipient,
                            child: Text('Add another recipient'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  primary: _selectedDeliveryMethod == 'Deliver'
                                      ? Colors.white : Color(0xFF1AB428),
                                  side: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  backgroundColor: _selectedDeliveryMethod == 'Deliver'
                        ? Color(0xFF1AB428) : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedDeliveryMethod = 'Deliver';
                                  });
                                },
                                child: Text('Deliver'),
                              ),
                              SizedBox(width: 8),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  primary: _selectedDeliveryMethod == 'Pickup'
                                      ? Colors.white : Color(0xFF1AB428),
                                  side: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  backgroundColor: _selectedDeliveryMethod == 'Pickup'
                                      ? Color(0xFF1AB428) : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedDeliveryMethod = 'Pickup';
                                  });
                                },
                                child: Text('Pickup'),
                              ),
                              SizedBox(width: 8),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  primary: _selectedDeliveryMethod == 'Digital'
                                      ? Colors.white : Color(0xFF1AB428),
                                  side: BorderSide(
                                    color: Colors.grey,
                                  ),
                                  backgroundColor: _selectedDeliveryMethod == 'Digital'
                                      ? Color(0xFF1AB428) : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedDeliveryMethod = 'Digital';
                                  });
                                },
                                child: Text('Digital'),
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          ..._contactsControllers
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            TextEditingController controller = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == _contactsControllers.length - 1 ? 0.0 : 16.0,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      cursorColor: Color(0xFFEF911E),
                                      controller: controller,
                                      decoration: InputDecoration(
                                        labelText: 'Contact Information',
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
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter at least one contact';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  if (_contactsControllers.length > 1)
                                    IconButton(
                                      padding: EdgeInsets.all(0),
                                      constraints: BoxConstraints.tight(Size(24, 24)),
                                      onPressed: () => _removeContact(index),
                                      icon:
                                      Icon(Icons.close, color: Color(0xFFEF911E)),
                                    ),
                                ],
                              ),
                            );
                          }),
                          TextButton(
                            onPressed: _addContact,
                            child: Text('Add another contact information'),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton<String>(
                                value: _selectedPremadeGroup,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedPremadeGroup = newValue!;
                                  });
                                },
                                style: TextStyle(fontSize: 15, color: Color(0xFFEF911E)),
                                items: _premadeGroups.keys.map<DropdownMenuItem<String>>((String key) {
                                  return DropdownMenuItem<String>(
                                    value: key,
                                    child: Text(key),
                                  );
                                }).toList(),
                              ),
                              ..._premadeGroups[_selectedPremadeGroup]!.map((status) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        primary: Color(0xFF1AB428),
                                        side: BorderSide(
                                          color: Color(0xFFEF911E),
                                        ),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                        ),
                                      ),
                                      onPressed: () => _onEditCustomButton(status),
                                      child: status.label.length > 25
                                          ? Container(
                                        width: 200,
                                        child: Text(
                                          status.label,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                          : Text(status.label),
                                    ),
                                    IconButton(
                                      onPressed:
                                      status.label == 'Pending' ? null : () {
                                        setState(() {
                                          _premadeGroups[_selectedPremadeGroup]!.remove(status);
                                        });
                                      },
                                      icon:
                                      Icon(Icons.close, color: status.label == 'Pending' ? Colors.grey : Color(0xFFEF911E)),
                                    ),
                                  ],
                                );
                              }).toList(),
                              TextButton(
                                onPressed: _onAddStatusButton,
                                child: Text(
                                  'Add order status',
                                  style: TextStyle(color: Color(0xFFEF911E)),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: _onRemoveSelectedGroup,
                                      child:
                                      Text(
                                          'Remove group', 
                                          style: TextStyle(color:
                                      _selectedPremadeGroup == 'Default' ? Colors.black12 : Colors.grey))
                                  ),
                                  TextButton(
                                    onPressed: _onAddGroupStatusButton,
                                    child: 
                                    Text(
                                      'Add order status group',
                                      style: TextStyle(color: Color(0xFFEF911E)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0.0),
                            child: TextFormField(
                              maxLines: null, // Set maxLines to null to allow for infinite lines
                              decoration: InputDecoration(
                                labelText: 'Additional Message',
                                labelStyle: TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide:
                                  BorderSide(color: Colors.grey),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide:
                                  BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide:
                                  BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: _onCancel,
                                  style: TextButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.close),
                                      SizedBox(width: 0),
                                      Text('Cancel'),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: _onReset,
                                  style: TextButton.styleFrom(
                                    primary: Colors.grey,
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.refresh),
                                      SizedBox(width: 0),
                                      Text('Reset'),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _onPlaceOrder,
                                  style: ElevatedButton.styleFrom(
                                    shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    backgroundColor: Color(0xFF1AB428),
                                  ),
                                  child: const Row(
                                    children: [
                                      SizedBox(width: 0),
                                      Text('Place Order'),
                                      Icon(Icons.check),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}