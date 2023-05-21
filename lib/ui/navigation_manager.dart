import 'package:flutter_bloc/flutter_bloc.dart';
import 'pages/place_order.dart';
import 'pages/inventory_view.dart';
import 'pages/order_status.dart';

enum NavigationEvents
{
  placeOrderPageClickedEvent,
  orderStatusPageClickedEvent,
  inventoryPageClickedEvent,
}

mixin NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates>
{
  NavigationBloc(NavigationStates initialState) : super(initialState);

  NavigationStates get initialState => PlaceOrderPage();

  Stream<NavigationStates> mapEventToState(NavigationEvents event) async*
  {
    switch (event)
    {
      case NavigationEvents.placeOrderPageClickedEvent:
        yield PlaceOrderPage();
        break;
      case NavigationEvents.orderStatusPageClickedEvent:
        yield OrderStatusPage();
        break;
      case NavigationEvents.inventoryPageClickedEvent:
        yield InventoryPage();
        break;
    }
  }
}