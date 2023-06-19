import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bizbuddyproject/ui/input_forms/all_input_forms.dart';
import '../../classes/all_classes.dart';
import '../../models/all_models.dart';
import '../components/all_components.dart';

/*
* FIXME: catalog items duplicates when order tile is pressed
*  TODO: retain premadeGroups
* */

class OrderStatusPage extends StatefulWidget {
  final ValueNotifier<bool> searchButtonPressed;

  const OrderStatusPage({
    Key? key,
    required this.searchButtonPressed,
  }) : super(key: key);

  @override
  State<OrderStatusPage> createState() {
    return _OrderStatusPageState();
  }
}

class _OrderStatusPageState extends State<OrderStatusPage> {

  final TextEditingController _searchController = TextEditingController();
  final orderStatusNotifier = ValueNotifier<LinkedHashSet<Order>>(
    LinkedHashSet<Order>(),
  );
  final ScrollController _scrollController = ScrollController();
  bool _isSearchFieldVisible = false;
  String _selectedSortOption = 'Default';
  final List<String> _sortOptions = ['Default', 'Order Id', 'Price', 'Date placed', 'Status'];
  final List<IconData> _sortOptionIcons = [
    Icons.sort,
    Icons.format_list_numbered,
    Icons.attach_money,
    Icons.date_range,
    Icons.assignment_turned_in,
  ];
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    widget.searchButtonPressed.addListener(_searchButtonPressed);
    orderStatusNotifier.value = Provider.of<OrderModel>(context, listen: false).orders;
  }

  @override
  void dispose() {
    widget.searchButtonPressed.removeListener(_searchButtonPressed);
    super.dispose();
  }

  void _searchButtonPressed() {
    setState(() {
      _isSearchFieldVisible = !_isSearchFieldVisible;
    });
  }

  LinkedHashSet<Order> searchOrders(String query) {
    final orderModel = Provider.of<OrderModel>(context, listen: false).orders;
    return LinkedHashSet<Order>.from(orderModel.where((order) {
      final nameMatch = order.recipient.name.toLowerCase().contains(query.toLowerCase());
      final idMatch = order.orderId.toLowerCase().contains(query.toLowerCase());
      final contactMatch = order.recipient.contacts[order.deliveryMethod]?.any(
              (contact) => contact.toLowerCase().contains(query.toLowerCase()));
      final descriptionMatch = order.description.toLowerCase().contains(query.toLowerCase());
      final deliveryMethod = order.deliveryMethod.toLowerCase().contains(query.toLowerCase());
      return nameMatch || contactMatch! || idMatch || descriptionMatch || deliveryMethod;
    }));
  }

  void _performSearch(String query) {
    setState(() {
      orderStatusNotifier.value = searchOrders(query);
    });
  }

  void _clearSearchField () {
    setState(() {
      _searchController.clear();
      orderStatusNotifier.value = Provider.of<OrderModel>(context, listen: false).orders;
    });
  }

  LinkedHashSet<Order> sortOrders(String sortOption, bool isAscending) {
    final orderModel = Provider.of<OrderModel>(context, listen: false).orders;
    List<Order> sortedOrders = orderStatusNotifier.value.toList();
    if (sortOption == 'Order Id') {
      sortedOrders.sort((a, b) => isAscending ? a.orderId.compareTo(b.orderId) : b.orderId.compareTo(a.orderId));
    } else if (sortOption == 'Price') {
      sortedOrders.sort((a, b) => isAscending ? a.calculateOrderTotalValue().compareTo(b.calculateOrderTotalValue()) : b.calculateOrderTotalValue().compareTo(a.calculateOrderTotalValue()));
    } else if (sortOption == 'Date placed') {
      sortedOrders.sort((a, b) => isAscending ? a.datePlaced.compareTo(b.datePlaced) : b.datePlaced.compareTo(a.datePlaced));
    } else if (sortOption == 'Status') {
      sortedOrders.sort((a, b) => isAscending ? a.currentStatusIndex.compareTo(b.currentStatusIndex) : b.currentStatusIndex.compareTo(a.currentStatusIndex));
    } else {
      // Default sort option
      if (!isAscending) {
        sortedOrders = (orderModel.toList()).reversed.toList();
      } else {
        sortedOrders = orderModel.toList();
      }
    }
    return LinkedHashSet.from(sortedOrders);
  }

  void _performSort(String sortOption, bool isAscending) {
    setState(() {
      orderStatusNotifier.value = sortOrders(sortOption, isAscending);
    });
  }

  void _onOrderCancel(Order order) {
    Provider.of<OrderModel>(context, listen: false).removeOrder(order);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Order cancelled'),
        backgroundColor: const Color(0xFF616161),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 6.0,
        margin: const EdgeInsets.only(bottom: 10.0),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          textColor: const Color(0xFFEF911E),
          onPressed: () {
            Provider.of<OrderModel>(context, listen: false).addOrder(order);
          },
        ),
      ),
    );
  // TODO: cancel
  }

  void _onOrderEdit(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditOrderPage(
          order: order,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderModel = Provider.of<OrderModel>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xFFEEEDF1),
      // floatingActionButton: Column(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     const SizedBox(height: 10),
      //     FloatingActionButton(
      //       onPressed: () {},
      //       backgroundColor: Color(0xFF1AB428),
      //       elevation: 1,
      //       child: const Icon(
      //         Icons.add,
      //         color: Colors.white,
      //         size: 30,
      //       ),
      //       heroTag: 'addLabelButton',
      //       tooltip: 'Add order process phase',
      //     ),
      //   ],
      // ),
      body: orderModel.orders.isEmpty
          ? const Center(
        child: Text(
          'No orders placed yet.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      )
          : Column(
        children: [
          SizedBox(
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 16,
                  ),
                  onPressed: () {
                    setState(() {
                      _isAscending = !_isAscending;
                      _performSort(_selectedSortOption, _isAscending);
                    });
                  },
                  splashRadius: 15,
                ),
                DropdownButton<String>(
                  dropdownColor: Colors.white,
                  value: _selectedSortOption,
                  items: _sortOptions.asMap().entries.map((entry) {
                    int index = entry.key;
                    String item = entry.value;
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Icon(
                            _sortOptionIcons[index],
                            color: Colors.black38,
                            size: 18,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSortOption = newValue!;
                      _performSort(newValue, _isAscending);
                    });
                  },
                  underline: const SizedBox(),
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            ),
          ),
          if(_isSearchFieldVisible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                cursorColor: const Color(0xFFEF911E),
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFFEF911E),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearchField,
                  ),
                ),
                onChanged: _performSearch,
              ),
            ),
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                scrollbarTheme: ScrollbarThemeData(
                  thumbColor: MaterialStateProperty.all(Colors.black54),
                ),
              ),
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 3,
                interactive: true,
                child: Consumer<OrderModel>(
                    builder: (context, orderStatusModel, child) {
                      orderStatusNotifier.value = orderStatusModel.orders;
                    return ValueListenableBuilder<LinkedHashSet<Order>>(
                        valueListenable: orderStatusNotifier,
                        builder: (context, productCatalog, child) {
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: productCatalog.length + 1,
                          itemBuilder: (context, index) {
                            if (index == productCatalog.length) {
                              return Container(height: kFloatingActionButtonMargin + 100);
                            }
                            final order = productCatalog.elementAt(index);
                            // TODO: return tile
                            return OrderTile(
                              order: order,
                              onOrderCancel: _onOrderCancel,
                              onOrderEdit: _onOrderEdit,
                            );
                          },
                        );
                      }
                    );
                  }
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}