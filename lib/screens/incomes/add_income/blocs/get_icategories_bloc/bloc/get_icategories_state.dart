part of 'get_icategories_bloc.dart';

enum IncCategoriesOverviewStatus { initial, loading, success, failure }

class GetIncCategoriesState extends Equatable {
  const GetIncCategoriesState({
    this.status = IncCategoriesOverviewStatus.initial,
    this.incCategories = const [],
  });

  final IncCategoriesOverviewStatus status;
  final List<IncCategory> incCategories;

  GetIncCategoriesState copyWith({
    IncCategoriesOverviewStatus Function()? status,
    List<IncCategory> Function()? incCategories,
  }) {
    return GetIncCategoriesState(
      status: status != null ? status() : this.status,
      incCategories: incCategories != null ? incCategories() : this.incCategories,
    );
  }

  @override
  List<Object?> get props => [
        status,
        incCategories,
      ];
}
