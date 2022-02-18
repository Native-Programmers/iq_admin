import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qb_admin/models/models.dart';
import 'package:qb_admin/models/orders.dart';
import 'package:qb_admin/repositories/orders/order_repository.dart';
part 'orders_event.dart';
part 'orders_state.dart';

// ignore: camel_case_types
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository _OrdersRepository;
  StreamSubscription? _OrdersSubscription;
  OrdersBloc({required OrdersRepository OrdersRepository})
      : _OrdersRepository = OrdersRepository,
        super(OrdersLoading());
  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is LoadOrders) {
      yield* _mapLoadOrdersToState();
    }
    if (event is UpdateOrders) {
      yield* _mapUpdateOrdersToState(event);
    }
  }

  Stream<OrdersState> _mapLoadOrdersToState() async* {
    _OrdersSubscription?.cancel();
    _OrdersSubscription = _OrdersRepository.getAllOrders().listen(
      (orders) => add(
        UpdateOrders(orders),
      ),
    );
  }

  Stream<OrdersState> _mapUpdateOrdersToState(UpdateOrders event) async* {
    yield OrdersLoaded(orders: event.orders);
  }
}
