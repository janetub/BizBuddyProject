import 'package:flutter/material.dart';
import '../../classes/all.dart';
import '../components/order_tile.dart';

/*
*
* */

class OrderStatusPage extends StatefulWidget {
  final Set<Order> orders;

  OrderStatusPage({
    Key? key,
    required this.orders,
  }) : super(key: key);

  @override
  _OrderStatusPageState createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {

  final TextEditingController _searchController = TextEditingController();
  Set<Item> filteredItems = {};
  final ScrollController _scrollController = ScrollController();
  bool _isSearchFieldVisible = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 15; i++) {
      // Create a new Item with varying values
      Item item = Item('Item $i', 'Item description $i');
      item.cost = i + 1;
      item.markup = i + 2;
      item.quantity = i + 3;

      // Create a new Person with varying values
      Person customer = Person('First Name $i', 'Middle Name $i', 'Last Name $i');
      Order order;
      if(i%2==0) {
        // Create a new Order with varying values
        Person customer2 = Person('Maya Jade Elise', '', 'Tubigon');
        order = Order(items: {item}, customers: [customer, customer2]);
      }
      else {
        // Create a new Order with varying values
        order = Order(items: {item}, customers: [customer]);
      }
      order.addStatus(OrderStatus(label: 'Status ${i % 4}', details: 'Status details ${i % 4}'));
      order.nextStatus();

      // Add the new Order to the list of orders
      widget.orders.add(order);
    }
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