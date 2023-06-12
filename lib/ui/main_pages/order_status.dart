import 'dart:collection';

import 'package:bizbuddyproject/ui/input_forms/edit_order.dart';
import 'package:flutter/material.dart';
import '../../classes/all.dart';
import '../components/order_tile.dart';

/*
* FIXME: catalog items duplicates when order tile is pressed
* */

class OrderStatusPage extends StatefulWidget {
  final LinkedHashSet<Order> orders;
  final ValueChanged<VoidCallback> onSearchButtonPressed;

  OrderStatusPage({
    Key? key,
    required this.orders,
    required this.onSearchButtonPressed,
  }) : super(key: key);

  @override
  _OrderStatusPageState createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {

  final TextEditingController _searchController = TextEditingController();
  LinkedHashSet<Order> _displayedOrders = LinkedHashSet<Order>();
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
    widget.onSearchButtonPressed(_searchButtonPressed);
    // for (int i = 0; i < 15; i++) {
    //   Item item = Item('Item $i', 'Item description $i');
    //   item.cost = i + 1;
    //   item.markup = i + 2;
    //   item.quantity = i + 3;
    //
    //   Person customer = Person('Name $i');
    //   Order order;
    //   if (i % 2 == 0) {
    //     Person customer2 = Person('Maya Jade Elise Tubigon');
    //     order = Order(
    //       items: LinkedHashSet<Item>.from({item}),
    //       recipient: customer2,
    //     );
    //   } else {
    //     order = Order(
    //       items: LinkedHashSet<Item>.from({item}),
    //       recipient: customer,
    //     );
    //   }
    //   List<OrderStatus> orderStatuses = [
    //     OrderStatus(label: 'Pending', description: 'Details 1'),
    //     OrderStatus(label: 'Packaging', description: 'Details 2'),
    //     OrderStatus(label: 'Waiting for pickup', description: 'Details 3'),
    //     OrderStatus(label: 'Received', description: 'Details 4'),
    //     OrderStatus(label: 'Paid', description: 'Details 5'),
    //   ];
    //   order.statuses.addAll(orderStatuses);
    //   order.nextStatus();
    //
    //   widget.orders.add(order);
    // }
    _displayedOrders = widget.orders;
  }

  void _searchButtonPressed() {
    setState(() {
      _isSearchFieldVisible = !_isSearchFieldVisible;
    });
  }

  LinkedHashSet<Order> searchOrders(String query) {
    return LinkedHashSet<Order>.from(widget.orders.where((order) {
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
      _displayedOrders = searchOrders(query);
    });
  }

  void _clearSearchField () {
    setState(() {
      _searchController.clear();
      _displayedOrders = widget.orders;
    });
  }

  LinkedHashSet<Order> sortOrders(String sortOption, bool isAscending) {
    List<Order> sortedOrders = _displayedOrders.toList();
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
        sortedOrders = (widget.orders.toList()).reversed.toList();
      } else {
        sortedOrders = widget.orders.toList();
      }
    }
    return LinkedHashSet.from(sortedOrders);
  }

  void _performSort(String sortOption, bool isAscending) {
    setState(() {
      _displayedOrders = sortOrders(sortOption, isAscending);
    });
  }


  void _onOrderCancel(Order order) {

  }

  void _onOrderEdit(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditOrderPage(
          order: order,
          onSubmit: (editedOrder) {
            setState(() {
              print('$order\n-----------\n$editedOrder');
              widget.orders.remove(order);
              widget.orders.add(editedOrder);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: widget.orders == null || widget.orders!.isEmpty
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
                            style: TextStyle(
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
                  underline: SizedBox(),
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            ),
          ),
          if(_isSearchFieldVisible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                cursorColor: Color(0xFFEF911E),
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFFEF911E),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
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
                isAlwaysShown: true,
                thickness: 3,
                interactive: true,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _displayedOrders.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _displayedOrders.length) {
                      return Container(height: kFloatingActionButtonMargin + 100);
                    }
                    final order = _displayedOrders.elementAt(index);
                    // TODO: return tile
                    return OrderTile(
                      order: order,
                      onOrderCancel: _onOrderCancel,
                      onProductEdit: _onOrderEdit,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}