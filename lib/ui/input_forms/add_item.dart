import 'dart:collection';

import 'package:flutter/material.dart';
import '../../classes/all.dart';
import '../components/inventory_search_dialog.dart';

class AddItemPage extends StatefulWidget {
  final Function(Item) onSubmit;
  final Inventory inventory;

  AddItemPage({
    required this.onSubmit,
    required this.inventory,
  });

  @override
  _AddItemPageState createState() => _AddItemPageState();
}
class _AddItemPageState extends State<AddItemPage>
{
  final _costFocusNode = FocusNode();
  final _markupFocusNode = FocusNode();
  final _stocksFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _costInfoButton = GlobalKey<FormState>();
  final _markupInfoButton = GlobalKey<FormState>();
  final _stocksInfoButton = GlobalKey<FormState>();

  final LinkedHashSet<Item> _selectedComponents = LinkedHashSet<Item>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _markupController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateBoughtController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  final List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _costFocusNode.addListener(() {
      setState(() {});
    });
    _markupFocusNode.addListener(() {
      setState(() {});
    });
    _stocksFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _costFocusNode.dispose();
    _markupFocusNode.dispose();
    _stocksFocusNode.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (_formKey.currentState!.validate()) {
      try {
        String costText = _costController.text.replaceAll(',', '');
        String markupText = _markupController.text.replaceAll(',', '');
        String quantityText = _quantityController.text.replaceAll(',', '');
        final newItem = Item(_nameController.text, _descriptionController.text);
        newItem.cost = double.parse(costText);
        newItem.markup = double.parse(markupText);
        newItem.quantity += (int.parse(quantityText));
        if (_dateBoughtController.text.isNotEmpty) {
          final dateParts = _dateBoughtController.text.split('/');
          final formattedDate = '${dateParts[2]}-${dateParts[0].padLeft(2, '0')}-${dateParts[1].padLeft(2, '0')}';
          final date = DateTime.parse(formattedDate);
          newItem.dateAdded = date;
        }
        newItem.tags.addAll(_tags);
        for (final component in _selectedComponents) {
          newItem.addComponent(component);
        }
        widget.onSubmit(newItem);

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
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }
    }
  }

  String? validateWholeIntegers(value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be left blank';
    }
    if (!RegExp(r'^\d{1,3}(,\d{3})*$').hasMatch(value)) {
      return 'Please input valid whole numbers';
    }
    return null;
  }

  String? validateIntegersAndDecimal(value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be left blank';
    }
    if (!RegExp(r'^\d{1,3}(,\d{3})*(\.\d+)?$').hasMatch(value)) {
      return 'Invalid input';
    }
    return null;
  }

  void onDeleteTag(String tag) {
    setState(() => _tags.remove(tag));
  }

  void _addToComponents(Item item, int quantity) {
    if (quantity > 0) {
      bool containsItem = _selectedComponents.any((componentItem) => componentItem.name == item.name);
      if (containsItem) {
        // component already exists in components
        setState(() {
          Item componentItem = _selectedComponents.firstWhere((componentItem) => componentItem.name == item.name);
          componentItem.quantity += quantity;
        });
      } else {
        // new product in components
        setState(() {
          Item movProd = item.duplicate();
          movProd.quantity = quantity;
          _selectedComponents.add(movProd);
        });
      }
    }
    _updateCostController();
  }

  void _updateCostController() {
    if (_selectedComponents.isNotEmpty) {
      final costSum = _selectedComponents.fold(0.00, (sum, component) => sum + component.cost);
      _costController.text = costSum.toStringAsFixed(2);
    } else {
      _costController.clear();
    }
  }

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onReset() {
    setState(() {
      _nameController.clear();
      _costController.clear();
      _markupController.clear();
      _quantityController.clear();
      _dateBoughtController.clear();
      _tagController.clear();
      _tags.clear();
      _descriptionController.clear();
      _selectedComponents.clear();
    });
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
                //expandedHeight: 100,
                backgroundColor: Colors.transparent,
                title: Text('Add an item'),
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
                        children: [
                          TextFormField(
                            cursorColor: Color(0xFFEF911E),
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Item Name',
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
                              if (value==null || value.isEmpty) {
                                return 'Field cannot be left blank';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            cursorColor: Color(0xFFEF911E),
                            focusNode: _costFocusNode,
                            controller: _costController,
                            decoration: InputDecoration(
                              labelText: 'Cost',
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
                              suffixIcon: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                key: _costInfoButton,
                                icon: Icon(
                                  Icons.info_outline,
                                  color: _costFocusNode.hasFocus ? Color(0xFFEF911E) : Colors.grey,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                        title: const Text('Cost'),
                                        content: const Text('Money spent to buy the product, the original cost. If an item has components, its cost will be the sum of the cost of its components.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                            style: TextButton.styleFrom(
                                              primary: Color(0xFFEF911E),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
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
                            keyboardType: _selectedComponents.isEmpty? TextInputType.number : TextInputType.none,
                            validator: validateIntegersAndDecimal,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            cursorColor: Color(0xFFEF911E),
                            focusNode: _markupFocusNode,
                            controller: _markupController,
                            decoration: InputDecoration(
                              labelText: 'Markup',
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
                              suffixIcon: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                key: _markupInfoButton,
                                icon: Icon(
                                  Icons.info_outline,
                                  color: _markupFocusNode.hasFocus ? Color(0xFFEF911E) : Colors.grey,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                        title: Text('Markup'),
                                        content: Text('Markup is the amount added to the cost of a product to determine its selling price.'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                            style: TextButton.styleFrom(
                                              primary: Color(0xFFEF911E),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
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
                            keyboardType: TextInputType.number,
                            validator: validateIntegersAndDecimal,
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  cursorColor: Color(0xFFEF911E),
                                  focusNode: _stocksFocusNode,
                                  controller: _quantityController,
                                  decoration: InputDecoration(
                                    labelText: 'Stocks',
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
                                    suffixIcon: IconButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      key: _stocksInfoButton,
                                      icon: Icon(
                                        Icons.info_outline,
                                        color: _stocksFocusNode.hasFocus ? Color(0xFFEF911E) : Colors.grey,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                              title: Text('Stocks'),
                                              content: Text('The quantity entered will be automatically added to the inventory for tracking.'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('OK'),
                                                  style: TextButton.styleFrom(
                                                    primary: Color(0xFFEF911E),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: validateWholeIntegers,
                                ),
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 0),
                                    child: Material(
                                      shape: CircleBorder(),
                                      child: InkWell(
                                        customBorder: CircleBorder(),
                                        onTap: () {
                                          int currentValue = int.tryParse(_quantityController.text) ?? 0;
                                          setState(() {
                                            currentValue++;
                                            _quantityController.text = currentValue.toString();
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.arrow_upward,
                                            color: Color(0xFFEF911E),
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0),
                                    child: Material(
                                      shape: CircleBorder(),
                                      clipBehavior: Clip.antiAlias,
                                      color: Colors.transparent,
                                      child: InkWell(
                                        customBorder: CircleBorder(),
                                        onTap: () {
                                          int currentValue = int.tryParse(_quantityController.text) ?? 0;
                                          setState(() {
                                            currentValue--;
                                            if (currentValue < 0) currentValue = 0;
                                            _quantityController.text = currentValue.toString();
                                          });
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Icon(
                                            Icons.arrow_downward,
                                            color: Color(0xFFEF911E),
                                            size: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            cursorColor: Color(0xFFEF911E),
                            controller: _dateBoughtController,
                            keyboardType: TextInputType.none,
                            decoration: InputDecoration(
                              labelText: 'Date Bought',
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
                            ),
                            onTap: () async {
                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: Color(0xFF1AB428),
                                        onPrimary: Colors.white,
                                        secondary: Colors.green,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (date != null) {
                                setState(() {
                                  _dateBoughtController.text =
                                  "${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}";
                                });
                              }
                            },
                          ),
                          SizedBox(height: 10),
                          // TODO: respond to enter key
                          TextFormField(
                            cursorColor: Color(0xFFEF911E),
                            controller: _tagController,
                            decoration: InputDecoration(
                              labelText: 'Tags',
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
                              suffixIcon: IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                icon: Icon(Icons.add),
                                color: Color(0xFFEF911E),
                                onPressed: () {
                                  setState(() {
                                    final tag = _tagController.text.trim();
                                    if (tag.isNotEmpty) {
                                      _tags.add(tag);
                                      _tagController.clear();
                                    }
                                  });
                                },
                              ),
                            ),
                            onChanged: (value){},
                          ),
                          Wrap(
                            spacing: 4,
                            runSpacing: 0,
                            children: _tags.map((tag) {
                              return TagTile(
                                tag,
                                    (tag) => onDeleteTag(tag),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              await showDialog<Item>(
                                context: context,
                                builder: (context) => InventorySearchDialog(
                                  inventory: widget.inventory,
                                  onAddToComponent: _addToComponents,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Color(0xFFEF911E),
                              // Color(0xFF00B894) represents the color #00B894
                              // Color(0xFF808080) represents the color #808080
                              // Color(0xFFFFC107) represents the color #FFC107
                            ),
                            child: const Column(
                              children: [
                                SizedBox(width: 4),
                                Text('Select Components'),
                              ],
                            ),
                          ),
                          Wrap(
                            spacing: 8.0,
                            children: _selectedComponents.map((rawMaterial) {
                              return Chip(
                                label: Text('(${rawMaterial.quantity}) ${rawMaterial.name}'),
                                onDeleted: () {
                                  setState(() {
                                    _selectedComponents.remove(rawMaterial);
                                    _updateCostController();
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            cursorColor: Color(0xFFEF911E),
                            controller: _descriptionController,
                            maxLines: null,
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
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
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
                                    SizedBox(width: 4),
                                    Text('Cancel'),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              TextButton(
                                onPressed: _onReset,
                                style: TextButton.styleFrom(
                                  primary: Colors.grey,
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.refresh),
                                    SizedBox(width: 4),
                                    Text('Reset'),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _onConfirm,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor: Color(0xFF1AB428),
                                  // Color(0xFF00B894) represents the color #00B894
                                  // Color(0xFF808080) represents the color #808080
                                  // Color(0xFFFFC107) represents the color #FFC107
                                ),
                                child: const Row(
                                  children: [
                                    SizedBox(width: 4),
                                    Text('Confirm'),
                                    Icon(Icons.check),
                                  ],
                                ),
                              ),
                            ],
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

class TagTile extends StatelessWidget {
  final String tag;
  final Function(String) onDeleteTag;

  TagTile(this.tag, this.onDeleteTag);

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 5.0),
      label: Text(tag),
      deleteIcon: const Icon(Icons.close),
      onDeleted: () => onDeleteTag(tag),
    );
  }
}
