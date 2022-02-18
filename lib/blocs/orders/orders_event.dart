part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class LoadOrders extends OrdersEvent {}

class UpdateOrders extends OrdersEvent {
  final List<Orders> orders;
  const UpdateOrders(this.orders);

  @override
  List<Object> get props => [orders];
}
