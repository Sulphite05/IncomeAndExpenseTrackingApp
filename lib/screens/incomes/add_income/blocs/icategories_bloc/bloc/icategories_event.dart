part of 'icategories_bloc.dart';

sealed class IncCategoriesEvent extends Equatable {
  const IncCategoriesEvent();

  @override
  List<Object> get props => [];
}

class GetIncCategories extends IncCategoriesEvent {}

class DeleteIncCategory extends IncCategoriesEvent {
  final String categoryId;

  const DeleteIncCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
