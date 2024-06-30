part of 'get_categories_bloc.dart';

enum CategoriesOverviewStatus { initial, loading, success, failure }

class GetCategoriesState extends Equatable {
  const GetCategoriesState({
    this.status = CategoriesOverviewStatus.initial,
    this.categories = const [],
  });

  final CategoriesOverviewStatus status;
  final List<ExpCategory> categories;

  GetCategoriesState copyWith({
    CategoriesOverviewStatus Function()? status,
    List<ExpCategory> Function()? categories,
  }) {
    return GetCategoriesState(
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
