import 'dart:collection';

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
  LinkedHashSet<Item> filteredItems = LinkedHashSet<Item>();
  final ScrollController _scrollController = ScrollController();
  bool _isSearchFieldVisible = false;

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
    //     import 'dart:collection';
    //
    // import 'all.dart';
    // /*
    // * This class represents a customer order.
    // * It can be pre-made or customized at the time the order is placed.
    // * Add attributes and methods to this class to manage the order’s status and other details.
    // * add feature typing number of quantity to order
    // * */
    //
    // /*
    // *
    // * */
    //
    // class Order {
    //   final String orderId;
    //   String description;
    //   final LinkedHashSet<Item> items;
    //   final LinkedHashSet<OrderStatus> statuses;
    //   int currentStatusIndex;
    //   DateTime datePlaced;
    //   final LinkedHashSet<Person> customers;
    //
    //   Order({required this.items, required this.customers}) : description = '', statuses = LinkedHashSet<OrderStatus>(), currentStatusIndex = -1, orderId = idGenerator(),
    //         datePlaced = DateTime.now() {
    //     if (items.isEmpty) {
    //       throw ArgumentError('An order must have at least one item.');
    //     }
    //     for (var item in items) {
    //       item.dateAdded = DateTime.now();
    //     }
    //   }
    //
    //   double calculateOrderTotalValue() {
    //     double totalCost = 0;
    //     for (Item item in items) {
    //       totalCost += item.calculateTotalValue();
    //     }
    //     return totalCost;
    //   }
    //
    //   static String idGenerator() {
    //     final now = DateTime.now();
    //     return now.microsecondsSinceEpoch.toString();
    //   }
    //
    //   void addItem(Item item) {
    //     items.add(item);
    //     item.dateAdded = DateTime.now();
    //   }
    //
    //   void removeItem(Item item) {
    //     items.remove(item);
    //   }
    //
    //   void addStatus(OrderStatus status)
    //   {
    //     statuses.add(status);
    //   }
    //
    //   double calculateTotalCost() {
    //     double totalCost = 0;
    //     for (Item item in items) {
    //       totalCost += item.cost * item.quantity;
    //     }
    //     return totalCost;
    //   }
    //
    //   double calculateTotalPrice() {
    //     double totalPrice = 0;
    //     for (Item item in items) {
    //       totalPrice += item.price * item.quantity;
    //     }
    //     return totalPrice;
    //   }
    //
    //   void nextStatus() {
    //     if (currentStatusIndex < statuses.length - 1) {
    //       currentStatusIndex++;
    //     }
    //   }
    //
    //   void previousStatus() {
    //     if (currentStatusIndex > 0) {
    //       currentStatusIndex--;
    //     }
    //   }
    //
    //   OrderStatus? getCurrentStatus() {
    //     if (currentStatusIndex >= 0 && currentStatusIndex < statuses.length) {
    //       return statuses.elementAt(currentStatusIndex);
    //     }
    //     return null;
    //   }
    //
    //   @override
    //   String toString() {
    //     return 'Order(orderId: ${orderId}, description: ${description}, items: ${items}, statuses: ${statuses}, currentStatusIndex: ${currentStatusIndex}, datePlaced: ${datePlaced}, customers: ${customers})\n------------------------\n';
    //   }
    // }  items: LinkedHashSet<Item>.from({item}),
    //       customers: LinkedHashSet<Person>.from([customer, customer2]),
    //     );
    //   } else {
    //     order = Order(
    //       items: LinkedHashSet<Item>.from({item}),
    //       customers: LinkedHashSet<Person>.from([customer]),
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
  }

  void _searchButtonPressed() {
    setState(() {
      _isSearchFieldVisible = !_isSearchFieldVisible;
      print('invisible');
    });
  }

  void _clearSearchField () {

  }

  void _performSearch(String query) {

  }

  void _onOrderCancel(Order order) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEDF1),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Color(0xFF1AB428),
            elevation: 1,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
            heroTag: 'addLabelButton',
            tooltip: 'Add order process phase',
          ),
        ],
      ),
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
                  itemCount: widget.orders.length + 1,
                  itemBuilder: (context, index) {
                    if (index == widget.orders.length) {
                      return Container(height: kFloatingActionButtonMargin + 100);
                    }
                    final order = widget.orders.elementAt(index);
                    // TODO: return tile
                    return OrderTile(
                      order: order,
                      onOrderCancel: _onOrderCancel,
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