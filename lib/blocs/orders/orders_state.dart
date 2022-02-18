part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<Orders> orders;

  const OrdersLoaded({this.orders = const <Orders>[]});

  @override
  List<Object> get props => [orders];
}

class OrdersError extends OrdersState {}
