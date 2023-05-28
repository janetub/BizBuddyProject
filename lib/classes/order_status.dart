/*
* This class represents the status of an order.
* Allow entrepreneurs to create their own statuses and labels for different stages of the order processing.
* */

class OrderStatus {
  final String label;
  final String details;

  OrderStatus({required this.label, required this.details});
}