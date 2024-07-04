part of 'create_icategory_bloc.dart';

sealed class CreateIncCategoryEvent extends Equatable {
  const CreateIncCategoryEvent();

  @override
  List<Object> get props => [];
}

class CreateIncCategory extends CreateIncCategoryEvent {
  final IncCategory incCategory;

  const CreateIncCategory(this.incCategory);

  @override
  List<Object> get props => [incCategory];
}
