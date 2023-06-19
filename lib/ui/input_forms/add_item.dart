import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../classes/all_classes.dart';
import '../../models/all_models.dart';
import '../components/all_components.dart';
import '../main_pages/all_main_pages.dart';

class AddItemPage extends StatefulWidget {
  final Type callingPage;

  const AddItemPage({
    Key? key,
    required this.callingPage,
  }) : super(key: key);

  @override
  State<AddItemPage> createState() {
    return _AddItemPageState();
  }
}
class _AddItemPageState extends State<AddItemPage> {
  final _nameFocusNode = FocusNode();
  final _costFocusNode = FocusNode();
  final _markupFocusNode = FocusNode();
  final _stocksFocusNode = FocusNode();
  final _dateBoughtFocusNode = FocusNode();
  final _tagsFocusNode = FocusNode();
  final _descrptionFocusNode = FocusNode();

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
    _nameFocusNode.addListener(() {
      setState(() {});
    });
    _costFocusNode.addListener(() {
      setState(() {});
    });
    _markupFocusNode.addListener(() {
      setState(() {});
    });
    _stocksFocusNode.addListener(() {
      setState(() {});
    });
    _dateBoughtFocusNode.addListener(() {
      setState(() {});
    });
    _tagsFocusNode.addListener(() {
      setState(() {});
    });
    _descrptionFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _costFocusNode.dispose();
    _markupFocusNode.dispose();
    _stocksFocusNode.dispose();
    _dateBoughtFocusNode.dispose();
    _tagsFocusNode.dispose();
    _descrptionFocusNode.dispose();
    super.dispose();
  }

  void _onConfirm() {
    if (_formKey.currentState!.validate()) {
      try {
        _costController.text = _costController.text.replaceAll(',', '');
        _markupController.text = _markupController.text.replaceAll(',', '');
        _quantityController.text = _quantityController.text.replaceAll(',', '');
        final newItem = Item(_nameController.text, _descriptionController.text);
        newItem.cost = double.parse(_costController.text);
        newItem.markup = double.parse(_markupController.text);
        newItem.quantity += (int.parse(_quantityController.text));
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

        final inventoryModel = Provider.of<InventoryModel>(context, listen: false);
        final productCatalogModel = Provider.of<ProductCatalogModel>(context, listen: false);
        final cartModel = Provider.of<CartModel>(context, listen: false);

        if ((productCatalogModel.productCatalog.any((existingItem) => existingItem.name.toLowerCase() == newItem.name.toLowerCase())) || (cartModel.cartItems.any((existingItem) => existingItem.name.toLowerCase() == newItem.name.toLowerCase())) || inventoryModel.inventoryItems.any((existingItem) => existingItem.name.toLowerCase() == newItem.name.toLowerCase())) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text('Duplicate Item'),
              content: const Text('An item with the same name already exists in the product catalog.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        } else {
          final newItemDup = newItem.duplicate();
          if(widget.callingPage == ProductCatalogPage) {
            if(_selectedComponents.isEmpty) { //add item in inventory
              inventoryModel.addItem(newItem);
            }
            productCatalogModel.addItem(newItemDup);
            Navigator.pop(context);
          }
          if (widget.callingPage == InventoryPage) {
            inventoryModel.addItem(newItem);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(widget.callingPage == ProductCatalogPage ? 'Product added' : 'Item added'),
                backgroundColor: const Color(0xFF616161),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 6.0,
                margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
    // characters other than digits, zero, and comma
    if(RegExp(r'[^0-9,]').hasMatch(value)) {
      return 'Please input a valid whole number';
    }
    if(value.toString().contains(',')) {
      // non-negative with thousands separator
      if (!RegExp(r'^\d{1,3}(,\d{3})*$').hasMatch(value)) {
        return 'Please input a valid whole number';
      }
    }
    return null;
  }

  String? validateIntegersAndDecimal(value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be left blank';
    }
    // characters other than digits, zero, and comma
    if(RegExp(r'[^0-9,.]').hasMatch(value)) {
      return 'Please input a valid number';
    }
    // non-negative whole numbers with comma placements and decimal
    if(value.toString().contains(',')) {
      if ((!RegExp(r'^\d{1,3}(,\d{3})*(\.\d+)?$').hasMatch(value))) {
        return 'Please input a valid number';
      }
    }
    // has more than one period
    if(value.toString().contains('.')) {
      // non-negative decimal numbers
      if((value.split('.').length - 1 > 1)) {
        return 'Please input a valid number';
      }
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
        Item componentItem = _selectedComponents.firstWhere((componentItem) => componentItem.name == item.name);
        if((item.quantity - componentItem.quantity) < quantity) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text('Insufficient Stock'),
                content: const Text('The requested quantity is not available.'),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFEF911E),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
        setState(() {
          componentItem.quantity += quantity;
        });
      } else {
        if(item.quantity < quantity) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text('Insufficient Stock'),
                content: const Text('The requested quantity is not available.'),
                actions: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFEF911E),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          return;
        }
        // new product in components
        setState(() {
          Item movProd = item.duplicate();
          movProd.quantity = quantity;
          _selectedComponents.add(movProd);
        });
      }
      _updateCostController();
    }
  }

  int calculateMaxProducts() {
    int maxProducts = 0;
    LinkedHashSet<Item> tempInventory = LinkedHashSet<Item>.from(
        Provider.of<InventoryModel>(context, listen: false).inventoryItems.map((item) => item.duplicate()),
    ); // deep copy

    // reduce by items in cart
    for (Item cartItem in Provider.of<CartModel>(context, listen: false).cartItems) {
      bool itemFound = tempInventory.any((i) => i.name == cartItem.name);
      if (itemFound) {
        Item foundItem = tempInventory.firstWhere((i) => i.name == cartItem.name);
        foundItem.quantity -= cartItem.quantity;
      }
    }

    // reduce by items in catalog
    for (Item prodCatItem in Provider.of<ProductCatalogModel>(context, listen: false).productCatalog) {
      bool itemFound = tempInventory.any((i) => i.name == prodCatItem.name);
      if (itemFound) {
        Item foundItem = tempInventory.firstWhere((i) => i.name == prodCatItem.name);
        foundItem.quantity -= prodCatItem.quantity;
      }
    }

    // has components and check each if in catalog or cart
    if(_selectedComponents.isNotEmpty) {
      for (Item item in _selectedComponents) {
        bool cartItemFound = Provider.of<CartModel>(context, listen: false).cartItems.any((c) => c.name == item.name);
        if(cartItemFound) { // found in cart
          Item cartItem = Provider.of<CartModel>(context, listen: false).cartItems.firstWhere((c) => c.name == item.name);
          bool itemFound = tempInventory.any((i) => i.name == cartItem.name);
          if (itemFound) { // confirm match of cartItem in inventory
            Item foundItem = tempInventory.firstWhere((i) => i.name == cartItem.name);
            foundItem.quantity -= cartItem.quantity; // reduce from invTemp
          }
        }
        bool prodCatItemFound = Provider.of<ProductCatalogModel>(context, listen: false).productCatalog.any((p) => p.name == item.name);
        if(prodCatItemFound) { // component found in catalog
          Item prodItem = Provider.of<ProductCatalogModel>(context, listen: false).productCatalog.firstWhere((c) => c.name == item.name);
          bool itemFound = tempInventory.any((i) => i.name == prodItem.name);
          if (itemFound) { // confirm match of catItem in inventory
            Item foundItem = tempInventory.firstWhere((i) => i.name == prodItem.name);
            foundItem.quantity -= prodItem.quantity; // reduce from invTemp
          }
        }
      }
    }

    // check inventory stocks
    while (true) {
      bool canCreateProduct = true;
      for (Item item in _selectedComponents) {
        bool itemFound = tempInventory.any((i) => i.name == item.name);
        if (itemFound) {
          Item foundItem = tempInventory.firstWhere((i) => i.name == item.name);
          if (foundItem.quantity >= item.quantity) {
            foundItem.quantity -= item.quantity;
          } else {
            canCreateProduct = false;
            break;
          }
        } else {
          canCreateProduct = false;
          break;
        }
      }
      if (canCreateProduct) {
        maxProducts += 1;
      } else {
        break;
      }
    }
    return maxProducts;
  }

  String? validateInventoryStocks(value) {
    String? validate = validateWholeIntegers(value);
    int max = calculateMaxProducts();
    int? val = int.tryParse(_quantityController.text);
    if(val != null && val > max) {
      return 'Inventory stocks are limited, $max max';
    }
    return validate;
  }

  void _updateCostController() {
    if (_selectedComponents.isNotEmpty) {
      final costSum = _selectedComponents.fold(0.00, (sum, component) => sum + component.calculateTotalCostValue());
      // print('${_selectedComponents} $costSum');
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

  void _openCalendar() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
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
      _tagsFocusNode.requestFocus();
    } else {
      _dateBoughtFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  title: Text('Add ${widget.callingPage == ProductCatalogPage ? 'a product' : 'an item'}'),
                  elevation: 0,
                  floating: true,
                  snap: true,
                ),
                SliverToBoxAdapter(
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
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
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              focusNode: _nameFocusNode,
                              onFieldSubmitted: (_) => _costFocusNode.requestFocus(),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              cursorColor: const Color(0xFFEF911E),
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'Product Name',
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
                                if (value==null || value.isEmpty) {
                                  return 'Field cannot be left blank';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => _markupFocusNode.requestFocus(),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              cursorColor: const Color(0xFFEF911E),
                              focusNode: _costFocusNode,
                              controller: _costController,
                              decoration: InputDecoration(
                                labelText: 'Cost',
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
                                suffixIcon: IconButton(
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  key: _costInfoButton,
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: _costFocusNode.hasFocus ? const Color(0xFFEF911E) : Colors.grey,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                          title: const Text('Cost'),
                                          content: const Text('Money spent to buy the product, the original cost. If an item has components, its cost will be the sum of the cost of its components.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: const Color(0xFFEF911E),
                                              ),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
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
                              keyboardType: _selectedComponents.isEmpty? TextInputType.number : TextInputType.none,
                              validator: validateIntegersAndDecimal,
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => _stocksFocusNode.requestFocus(),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              cursorColor: const Color(0xFFEF911E),
                              focusNode: _markupFocusNode,
                              controller: _markupController,
                              decoration: InputDecoration(
                                labelText: 'Markup',
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
                                suffixIcon: IconButton(
                                  focusColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  key: _markupInfoButton,
                                  icon: Icon(
                                    Icons.info_outline,
                                    color: _markupFocusNode.hasFocus ? const Color(0xFFEF911E) : Colors.grey,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                          title: const Text('Markup'),
                                          content: const Text('Markup is the amount added to the cost of a product to determine its selling price.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: TextButton.styleFrom(
                                                foregroundColor: const Color(0xFFEF911E),
                                              ),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: validateIntegersAndDecimal,
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    onFieldSubmitted: (_) {
                                      _openCalendar();
                                      _dateBoughtFocusNode.requestFocus();
                                    },
                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                    cursorColor: const Color(0xFFEF911E),
                                    focusNode: _stocksFocusNode,
                                    controller: _quantityController,
                                    decoration: InputDecoration(
                                      labelText: 'Stocks',
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
                                      suffixIcon: IconButton(
                                        focusColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        key: _stocksInfoButton,
                                        icon: Icon(
                                          Icons.info_outline,
                                          color: _stocksFocusNode.hasFocus ? const Color(0xFFEF911E) : Colors.grey,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                                                title: const Text('Stocks'),
                                                content: const Text('If a component is selected from inventory, the entered quantity must not exceed available stock. Otherwise, the product will be added as a new item to inventory and the entered quantity will be reflected.'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: const Color(0xFFEF911E),
                                                    ),
                                                    child: const Text('OK'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: _selectedComponents.isEmpty? validateWholeIntegers : validateInventoryStocks,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 0),
                                      child: Material(
                                        shape: const CircleBorder(),
                                        child: InkWell(
                                          customBorder: const CircleBorder(),
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
                                        shape: const CircleBorder(),
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.transparent,
                                        child: InkWell(
                                          customBorder: const CircleBorder(),
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
                            const SizedBox(height: 15),
                            TextFormField(
                              focusNode: _dateBoughtFocusNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => _tagsFocusNode.requestFocus(),
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              cursorColor: const Color(0xFFEF911E),
                              controller: _dateBoughtController,
                              keyboardType: TextInputType.none,
                              decoration: InputDecoration(
                                labelText: 'Date Bought',
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
                              ),
                              onTap: _openCalendar,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => _descrptionFocusNode.requestFocus(),
                              focusNode: _tagsFocusNode,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              cursorColor: const Color(0xFFEF911E),
                              controller: _tagController,
                              decoration: InputDecoration(
                                labelText: 'Tags',
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
                                suffixIcon: IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  icon: const Icon(Icons.add),
                                  color: const Color(0xFFEF911E),
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
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () async {
                                await showDialog<Item>(
                                  context: context,
                                  builder: (context) => InventorySearchDialog(
                                    onAddToComponent: _addToComponents,
                                    hideItem: null,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: const Color(0xFFEF911E),
                                padding: const EdgeInsets.fromLTRB(13,6,13,6),
                              ),
                              child: const Column(
                                children: [
                                  SizedBox(width: 4),
                                  Text('Select Components',
                                    textAlign: TextAlign.center,
                                  ),
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
                            const SizedBox(height: 10),
                            TextFormField(
                              onFieldSubmitted: (value) {
                                _onConfirm();
                              },
                              textInputAction: TextInputAction.done,
                              focusNode: _descrptionFocusNode,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              cursorColor: const Color(0xFFEF911E),
                              controller: _descriptionController,
                              maxLines: null,
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
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
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
                                      SizedBox(width: 4),
                                      Text('Cancel'),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: _onReset,
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.grey,
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.refresh),
                                      SizedBox(width: 4),
                                      Text('Reset'),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: _onConfirm,
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: const Color(0xFF1AB428),
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
      ),
    );
  }
}
