import 'package:flutter/material.dart';
import '../../classes/all.dart';
import '../components/inventory_search_dialog.dart';
/*
* TODO: products must not have the same names
* TODO: limit name input
* */
class AddItemPage extends StatefulWidget {
  final Function(Item) onSubmit;

  AddItemPage({required this.onSubmit});

  @override
  _AddItemPageState createState() => _AddItemPageState();
}
class _AddItemPageState extends State<AddItemPage>
{
  final _costFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _costFocusNode.addListener(() {
      setState(() {});
    });
    _priceFocusNode.addListener(() {
      setState(() {});
    });
    // TODO: for testing
    Item samp = Item('Flour', 'A powdery substance used for baking');
    inventory.addItem(samp);
    Item samp2 = Item('Sugar', 'A sweet crystalline substance');
    samp2.tags.add("brown");
    samp2.tags.add("sweet");
    samp2.tags.add("ingredients");
    samp2.tags.add("fats");
    samp2.quantity = 3;
    inventory.addItem(samp2);
    Item samp3 = Item('Eggs', 'A nutritious food produced by chickens');
    samp3.tags.add("white");
    inventory.addItem(samp3);
  }
  @override
  void dispose() {
    _costFocusNode.dispose();
    _priceFocusNode.dispose();
    super.dispose();
  }

  final Inventory inventory = Inventory();

  final Set<Item> _selectedComponents = {};

  final _formKey = GlobalKey<FormState>();
  final _costInfoButton = GlobalKey<FormState>();
  final _priceInfoButton = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _markupController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateBoughtController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final List<String> _tags = [];

  /* FIXME: reaches beyond the notification/task bar
   */
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
                title: Text('Add a product'),
                elevation: 0,
                floating: true,
                snap: true,
              ),
              SliverToBoxAdapter(
                child: Card(
                  color: Color(0xFFF9F9F9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin: EdgeInsets.all(30),
                  child: Padding(
                    padding: EdgeInsets.all(25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Product Name',
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
                                      content: const Text('Money spent to buy the product.\nOriginal cost.'),
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be left blank';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          focusNode: _priceFocusNode,
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
                              key: _priceInfoButton,
                              icon: Icon(
                                Icons.info_outline,
                                color: _priceFocusNode.hasFocus ? Color(0xFFEF911E) : Colors.grey,
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Field cannot be left blank';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
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
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a quantity';
                                  }
                                  return null;
                                },
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
                                "${date.month}/${date.day}/${date.year}";
                              });
                            }
                          },
                        ),
                        SizedBox(height: 10),
                        // TODO: respond to enter key
                        TextFormField(
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
                          spacing: 8,
                          runSpacing: 4,
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
                                inventory: inventory,
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
                              label: Text('${rawMaterial.name} (${rawMaterial.quantity})'),
                              onDeleted: () {
                                setState(() {
                                  _selectedComponents.remove(rawMaterial);
                                });
                              },
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
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
                                primary: Colors.red, // Set text color to red
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
                                primary: Colors.grey, // Set text color to red
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


  void onDeleteTag(String tag) {
    setState(() => _tags.remove(tag));
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
      _tags.clear();
      _descriptionController.clear();
      _selectedComponents.clear();
    });
  }

  void _onConfirm() {
    if (_formKey.currentState!.validate()) {
      final newItem = Item(_nameController.text, _descriptionController.text);
      newItem.cost = double.parse(_costController.text);
      newItem.markup = double.parse(_markupController.text);
      newItem.quantity += (int.parse(_quantityController.text));
      if(_dateBoughtController.text.isNotEmpty) {
        newItem.dateAdded = DateTime.parse(_dateBoughtController.text);
      }
      newItem.tags.addAll(_tags);
      newItem.components.addAll(_selectedComponents);
      widget.onSubmit(newItem);

      Navigator.pop(context);
    }
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
