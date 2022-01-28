import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qb_admin/models/product_model.dart';
import 'package:qb_admin/repositories/product/product_repository.dart';
part 'products_event.dart';
part 'products_state.dart';

// ignore: camel_case_types
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _productRepository;
  StreamSubscription? _productSubscription;
  ProductBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(ProductLoading());
  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if (event is LoadProduct) {
      yield* _mapLoadProductsToState();
    }
    if (event is UpdateProduct) {
      yield* _mapUpdateProductsToState(event);
    }
  }

  Stream<ProductState> _mapLoadProductsToState() async* {
    _productSubscription?.cancel();
    _productSubscription = _productRepository.getAllProducts().listen(
          (products) => add(
            UpdateProduct(products),
          ),
        );
  }

  Stream<ProductState> _mapUpdateProductsToState(UpdateProduct event) async* {
    yield ProductLoaded(products: event.products);
  }
}
