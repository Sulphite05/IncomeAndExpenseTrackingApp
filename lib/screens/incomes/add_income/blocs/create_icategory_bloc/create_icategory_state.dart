part of 'create_icategory_bloc.dart';

sealed class CreateIncCategoryState extends Equatable {
  const CreateIncCategoryState();

  @override
  List<Object> get props => [];
}

final class CreateIncCategoryInitial extends CreateIncCategoryState {}

final class CreateIncCategoryFailure extends CreateIncCategoryState {
  final String error;

  const CreateIncCategoryFailure(this.error);

  @override
  List<Object> get props => [error];
}

final class CreateIncCategoryLoading extends CreateIncCategoryState {}

final class CreateIncCategorySuccess extends CreateIncCategoryState {}
