/*
* This class represents the status of an order.
* Allow entrepreneurs to create their own statuses and labels for different stages of the order processing.
* */

class OrderStatus {
  String label;
  String description;

  OrderStatus({required this.label, required this.description});

  @override
  String toString() {
    return 'Label: ${label}, Description: ${description}\n';
  }
}