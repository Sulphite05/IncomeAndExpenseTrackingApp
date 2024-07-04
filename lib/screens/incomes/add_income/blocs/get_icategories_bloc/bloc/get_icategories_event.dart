part of 'get_icategories_bloc.dart';

sealed class GetIncCategoriesEvent extends Equatable {
  const GetIncCategoriesEvent();

  @override
  List<Object> get props => [];
}

class GetIncCategories extends GetIncCategoriesEvent {}

class DeleteIncCategory extends GetIncCategoriesEvent {
  final String categoryId;

  const DeleteIncCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}
