import 'dart:collection';
import 'package:bizbuddyproject/models/all_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../classes/all_classes.dart';

class EditOrderPage extends StatefulWidget {
  final Order order;

  const EditOrderPage({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<EditOrderPage> createState() {
    return _EditOrderPageState();
  }
}

class _EditOrderPageState extends State<EditOrderPage> {
  final ScrollController controller = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _msgController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final List<TextEditingController> _contactsControllers = [TextEditingController()];
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

  @override
  void initState() {
    super.initState();
    _msgController.text = widget.order.description;
    _nameController.text = widget.order.recipient.name;
    try{
      int index = 0;
      for (String contact in widget.order.recipient.contacts[widget.order.deliveryMethod]!) {
        if (index < _contactsControllers.length) {
          _contactsControllers[index].text = contact;
        } else {
          _contactsControllers.add(TextEditingController(text: contact));
        }
        index++;
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('No contacts found:\n'),
          content: const Text('Please add at least one contact information from the recipient.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK',
                style: TextStyle(color: Color(0xFFEF911E)),),
            ),
          ],
        ),
      );
    }
    _selectedPremadeGroup = 'Current';
    _premadeGroups[_selectedPremadeGroup] = LinkedHashSet.from(widget.order.statuses);
    _selectedDeliveryMethod = widget.order.deliveryMethod;
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

  Future<void> _onAddStatusButton() async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController labelController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add custom order status',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,),
          backgroundColor: const  Color(0xFFF9F9F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Form(
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
                style: TextStyle(color: Colors.grey),),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState != null && formKey.currentState!.validate()) {
                  Navigator.of(context).pop({
                    'label': labelController.text,
                    'description': descriptionController.text,
                  });
                }
              },
              child: const Text('OK',
                style: TextStyle(color: Color(0xFFEF911E)),),
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
          content: Form(
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
              },
              child: const Text('OK',
                style: TextStyle(color: Color(0xFFEF911E)),
              ),
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
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController labelController = TextEditingController();

    final resultGroupname = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add new order status group',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,),
          backgroundColor: const  Color(0xFFF9F9F9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  cursorColor: const Color(0xFFEF911E),
                  controller: labelController,
                  decoration: InputDecoration(
                    labelText: 'Status group name',
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
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel',
                style: TextStyle(color: Colors.grey),),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState != null &&
                    formKey.currentState!.validate()) {
                  Navigator.of(context).pop(labelController.text);
                }
              },
              child: const Text('OK',
                style: TextStyle(color: Color(0xFFEF911E)),),
            ),
          ],
        );
      },
    );
    if (resultGroupname != null) {
      final name = resultGroupname;
      setState(() {
        _premadeGroups[name] = LinkedHashSet<OrderStatus>();
        _premadeGroups[name]!.add(OrderStatus(label: 'Pending', description: ''));
        _selectedPremadeGroup = name;
      });
    }
  }

  void _onRemoveSelectedGroup() {
    if (_selectedPremadeGroup != 'Default') {
      setState(() {
        _premadeGroups.remove(_selectedPremadeGroup);
        _selectedPremadeGroup = 'Default';
        widget.order.currentStatusIndex = 0;
      });
    }
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onReset() {
    setState(() {
      for (final controller in _contactsControllers) {
        controller.clear();
      }
      _premadeGroups.clear(); //
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
      _nameController.clear();
      _contactsControllers.clear();
      _contactsControllers.add(TextEditingController());
      _msgController.clear();
    });
  }

  void _onConfirm() {
    // if at least one contact, remove empty text fields
    if (_contactsControllers.length > 1) {
      // at least one non-empty controller
      bool hasNonEmptyContact = _contactsControllers.any((controller) => controller.text.isNotEmpty);
      // remove empty
      if (hasNonEmptyContact) {
        for (int i = _contactsControllers.length - 1; i >= 0; i--) {
          if (_contactsControllers[i].text.isEmpty) {
            _removeContact(i);
          }
        }
      }
    }
    if(_formKey.currentState!.validate()) {
      try{
        Person person = Person(_nameController.text);
        for (int i = 0; i < _contactsControllers.length; i++) {
          String contact = _contactsControllers[i].text;
          person.addContact(_selectedDeliveryMethod, contact);
        }
        // deep copy
        // LinkedHashSet<Item> itemsDup = LinkedHashSet<Item>.from(
        //     widget.order.items.map((item) => item.duplicate()));
        widget.order.copyWith(
          recipient: person,
          description: _msgController.text,
          statuses: LinkedHashSet<OrderStatus>.from(
              _premadeGroups[_selectedPremadeGroup] as Iterable<OrderStatus>),
          deliveryMethod: _selectedDeliveryMethod,
        );

        // order is directly edited
        final orderModel = Provider.of<OrderModel>(context, listen: false);
        orderModel.updateOrder(widget.order);
        Navigator.pop(context);

      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Invalid entries:\n'),
            content: Text('$e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK',
                  style: TextStyle(color: Color(0xFFEF911E)),),
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
                  margin: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                  color: const Color(0xFFF9F9F9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: TextFormField(
                              cursorColor: const Color(0xFFEF911E),
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide:
                                  const BorderSide(color: Colors.grey),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide:
                                  const BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide:
                                  const BorderSide(color: Colors.red),
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
                          const SizedBox(height: 8,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _selectedDeliveryMethod == 'Pickup'
                                      ? Colors.white : const Color(0xFF1AB428), side: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                  backgroundColor: _selectedDeliveryMethod == 'Pickup'
                                      ? const Color(0xFF1AB428) : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedDeliveryMethod = 'Pickup';
                                  });
                                },
                                child: const Text('Pickup'),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _selectedDeliveryMethod == 'Deliver'
                                      ? Colors.white : const Color(0xFF1AB428), side: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                  backgroundColor: _selectedDeliveryMethod == 'Deliver'
                                      ? const Color(0xFF1AB428) : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedDeliveryMethod = 'Deliver';
                                  });
                                },
                                child: const Text('Deliver'),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: _selectedDeliveryMethod == 'Digital'
                                      ? Colors.white : const Color(0xFF1AB428), side: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                  backgroundColor: _selectedDeliveryMethod == 'Digital'
                                      ? const Color(0xFF1AB428) : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedDeliveryMethod = 'Digital';
                                  });
                                },
                                child: const Text('Digital'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8,),
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
                                      cursorColor: const Color(0xFFEF911E),
                                      controller: controller,
                                      decoration: InputDecoration(
                                        labelText: 'Contact Information',
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
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter at least one contact';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  if (_contactsControllers.length > 1)
                                    IconButton(
                                      padding: const EdgeInsets.all(0),
                                      constraints: BoxConstraints.tight(const Size(24, 24)),
                                      onPressed: () => _removeContact(index),
                                      icon:
                                      const Icon(Icons.close, color: Color(0xFFEF911E)),
                                    ),
                                ],
                              ),
                            );
                          }),
                          TextButton(
                            onPressed: _addContact,
                            child: const Text('Add another contact information',
                              style: TextStyle(color: Color(0xFFEF911E)),
                            ),
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
                                style: const TextStyle(fontSize: 15, color: Color(0xFFEF911E)),
                                items: _premadeGroups.keys.map<DropdownMenuItem<String>>((String key) {
                                  return DropdownMenuItem<String>(
                                      value: key,
                                      child: Text(
                                        key.length > 10 ? '${key.substring(0, 10)}...' : key,
                                        textAlign: TextAlign.center,
                                      )
                                  );
                                }).toList(),
                              ),
                              ..._premadeGroups[_selectedPremadeGroup]!.map((status) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: const Color(0xFF1AB428), side: const BorderSide(
                                          color: Color(0xFFEF911E),
                                        ),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                        ),
                                      ),
                                      onPressed: () => _onEditCustomButton(status),
                                      child: status.label.length > 25
                                          ? SizedBox(
                                        width: 200,
                                        child: Text(
                                          status.label,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                          : Text(status.label),
                                    ),
                                    IconButton(
                                      onPressed: status.label == 'Pending' || status == widget.order.getCurrentStatus()
                                          ? null
                                          : () {
                                        setState(() {
                                          _premadeGroups[_selectedPremadeGroup]!.remove(status);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: status.label == 'Pending' || status == widget.order.getCurrentStatus()
                                            ? Colors.black12
                                            : const Color(0xFFEF911E),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                              TextButton(
                                onPressed: _onAddStatusButton,
                                child: const Text(
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
                                    const Text(
                                      'Add order status group',
                                      style: TextStyle(color: Color(0xFFEF911E)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 8,),
                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: TextFormField(
                              cursorColor: const Color(0xFFEF911E),
                              controller: _msgController,
                              maxLines: null, // Set maxLines to null to allow for infinite lines
                              decoration: InputDecoration(
                                labelText: 'Additional Message',
                                labelStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide:
                                  const BorderSide(color: Colors.grey),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide:
                                  const BorderSide(color: Colors.red),
                                ),
                                focusedErrorBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                  borderSide:
                                  const BorderSide(color: Colors.red),
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
                                    foregroundColor: Colors.red,
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
                                    foregroundColor: Colors.grey,
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.refresh),
                                      SizedBox(width: 0),
                                      Text('Reset'),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _onConfirm,
                                  style: ElevatedButton.styleFrom(
                                    shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    backgroundColor: const Color(0xFF1AB428),
                                  ),
                                  child: const Row(
                                    children: [
                                      SizedBox(width: 0),
                                      Text('Confirm'),
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