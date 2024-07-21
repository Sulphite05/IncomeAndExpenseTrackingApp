part of 'categories_bloc.dart';

enum CategoriesOverviewStatus { initial, loading, success, failure }

class CategoriesState extends Equatable {
  const CategoriesState({
    this.status = CategoriesOverviewStatus.initial,
    this.categories = const [],
  });

  final CategoriesOverviewStatus status;
  final List<ExpCategory> categories;

  CategoriesState copyWith({
    CategoriesOverviewStatus Function()? status,
    List<ExpCategory> Function()? categories,
  }) {
    return CategoriesState(
      status: status != null ? status() : this.status,
      categories: categories != null ? categories() : this.categories,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categories,
      ];
}
