part of 'icategories_bloc.dart';

sealed class IncCategoriesEvent extends Equatable {
  const IncCategoriesEvent();

  @override
  List<Object> get props => [];
}

class CreateIncCategory extends IncCategoriesEvent {
  final IncCategory incCategory;

  const CreateIncCategory(this.incCategory);

  @override
  List<Object> get props => [incCategory];
}

class GetIncCategories extends IncCategoriesEvent {}

class DeleteIncCategory extends IncCategoriesEvent {
  final String categoryId;

  const DeleteIncCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
