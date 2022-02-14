part of 'subcategory_bloc.dart';

abstract class SubCategoryState extends Equatable {
  const SubCategoryState();

  @override
  List<Object> get props => [];
}

class SubCategoryLoading extends SubCategoryState {}

class SubCategoryLoaded extends SubCategoryState {
  final List<SubCategories> subcategories;

  const SubCategoryLoaded({this.subcategories = const <SubCategories>[]});

  @override
  List<Object> get props => [subcategories];
}

class CategoryError extends SubCategoryState {}
