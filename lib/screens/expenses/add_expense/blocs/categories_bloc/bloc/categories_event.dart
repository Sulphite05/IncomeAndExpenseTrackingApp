part of 'categories_bloc.dart';

sealed class CategoriesEvent extends Equatable {
  const CategoriesEvent();

  @override
  List<Object> get props => [];
}

class CreateCategory extends CategoriesEvent {
  final ExpCategory category;

  const CreateCategory(this.category);

  @override
  List<Object> get props => [category];
}

class GetCategories extends CategoriesEvent {}

class DeleteCategory extends CategoriesEvent {
  final String categoryId;

  const DeleteCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
