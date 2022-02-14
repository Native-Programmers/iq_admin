import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qb_admin/models/category_model.dart';
import 'package:qb_admin/models/subcategories_model.dart';
import 'package:qb_admin/repositories/categories/category_repository.dart';
import 'package:qb_admin/repositories/subcategories/subcategories_repository.dart';
part 'subcategory_event.dart';
part 'subcategory_state.dart';

class SubCategoryBloc extends Bloc<SubCategoryEvent, SubCategoryState> {
  final SubCategoryRepository _subcategoryRepository;
  StreamSubscription? _subcategorySubscription;
  SubCategoryBloc({required SubCategoryRepository subcategoryRepository})
      : _subcategoryRepository = subcategoryRepository,
        super(SubCategoryLoading());
  @override
  Stream<SubCategoryState> mapEventToState(
    SubCategoryEvent event,
  ) async* {
    if (event is LoadSubCategories) {
      yield* _mapLoadSubCategoriesToState();
    }
    if (event is UpdateSubCategories) {
      yield* _mapUpdateSubCategoriesToState(event);
    }
  }

  Stream<SubCategoryState> _mapLoadSubCategoriesToState() async* {
    _subcategorySubscription?.cancel();
    _subcategorySubscription =
        _subcategoryRepository.getAllSubCategories().listen(
              (subCategories) => add(
                UpdateSubCategories(subCategories),
              ),
            );
  }

  Stream<SubCategoryState> _mapUpdateSubCategoriesToState(
      UpdateSubCategories event) async* {
    yield SubCategoryLoaded(subcategories: event.subcategories);
  }
}
