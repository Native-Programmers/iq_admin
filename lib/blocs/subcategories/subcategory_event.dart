part of 'subcategory_bloc.dart';

abstract class SubCategoryEvent extends Equatable {
  const SubCategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadSubCategories extends SubCategoryEvent {}

class UpdateSubCategories extends SubCategoryEvent {
  final List<SubCategories> subcategories;
  const UpdateSubCategories(this.subcategories);

  @override
  List<Object> get props => [subcategories];
}
