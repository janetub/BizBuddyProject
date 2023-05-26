import 'package:flutter/material.dart';
import '../../classes/all.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}
class _AddItemState extends State<AddItemPage>
{
  // TODO: review
  final List<Item> _rawMaterials = [
    Item('Flour', 'A powdery substance used for baking'),
    Item('Sugar', 'A sweet crystalline substance'),
    Item('Eggs', 'A nutritious food produced by chickens'),
  ];
  final Set<Item> _selectedRawMaterials = {};


  final _formKey = GlobalKey<FormState>();
  final _costInfoButton = GlobalKey<FormState>();
  final _priceInfoButton = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateBoughtController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final List<String> _tags = [];


  /* FIXME:
  * reaches beyond the notification/task bar
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
                          ),
                          validator: (value) {
                            if (value==null || value.isEmpty) {
                              return 'Field cannot be left blank';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 15),
                        /* FIXME:
                        * Info button disappearing
                         */
                        TextFormField(
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
                              key: _costInfoButton,
                              icon: Icon(Icons.info_outline),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Customize the padding
                                      title: const Text('Cost'),
                                      content: const Text('Money spent to buy the product. Original cost.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
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
                        /* FIXME:
                        * Info button disappearing
                         */
                        TextFormField(
                          controller: _priceController,
                          decoration: InputDecoration(
                            labelText: 'Price',
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
                              key: _priceInfoButton,
                              icon: Icon(Icons.info_outline),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Customize the padding
                                      title: Text('Price'),
                                      content: Text('Selling price of the product.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
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
                        /* FIXME: can only be clicked, no other input/keyboard interface
                        * icon on right
                        * can be null
                         */
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
                              lastDate: DateTime(2100),
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
                              icon: Icon(Icons.add),
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
                        DropdownButton<Item>(
                          hint: Text('Select Raw Materials'),
                          items: _rawMaterials.map((Item rawMaterial) {
                            return DropdownMenuItem<Item>(
                              value: rawMaterial,
                              child: Text(rawMaterial.name),
                            );
                          }).toList(),
                          onChanged: (Item? selectedRawMaterial) {
                            if (selectedRawMaterial != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  int quantity = 0;

                                  return AlertDialog(
                                    title: Text('Set Quantity'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Enter the quantity for ${selectedRawMaterial.name}:'),
                                        SizedBox(height: 10),
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          initialValue: quantity.toString(),
                                          onChanged: (value) {
                                            quantity = int.tryParse(value) ?? 0;
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedRawMaterial.addQuantity(quantity);
                                            _selectedRawMaterials.add(selectedRawMaterial);
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Confirm'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },

                        ),
                        Wrap(
                          spacing: 8.0,
                          children: _selectedRawMaterials.map((rawMaterial) {
                            return Chip(
                              label: Text('${rawMaterial.name} (${rawMaterial.quantity})'),
                              onDeleted: () {
                                setState(() {
                                  _selectedRawMaterials.remove(rawMaterial);
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
                              child: Row(
                                children: [
                                  Icon(Icons.close),
                                  SizedBox(width: 4),
                                  Text('Cancel'),
                                ],
                              ),
                              style: TextButton.styleFrom(
                                primary: Colors.red,
                              ),
                            ),
                            SizedBox(width: 8),
                            TextButton(
                              onPressed: _onReset,
                              child: Row(
                                children: [
                                  Icon(Icons.refresh),
                                  SizedBox(width: 4),
                                  Text('Reset'),
                                ],
                              ),
                              style: TextButton.styleFrom(
                                primary: Colors.grey,,
                              ),
                            ),
                            SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: _onConfirm,
                              child: Row(
                                children: [
                                  SizedBox(width: 4),
                                  Text('Confirm'),
                                  Icon(Icons.check),
                                ],
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Color(0xFF00B894),
                                // Color(0xFF00B894) represents the color #00B894
                                // Color(0xFF808080) represents the color #808080
                                // Color(0xFFFFC107) represents the color #FFC107
                              ),
                            ),
                          ],
                        ),
                      ],
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
      _priceController.clear();
      _quantityController.clear();
      _dateBoughtController.clear();
      _tags.clear();
      _descriptionController.clear();
    });
  }

  void _onConfirm() {
    if (_formKey.currentState!.validate()) {
      // Instantiate
      Navigator.pop(context);
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
