part of 'icategories_bloc.dart';

enum IncCategoriesOverviewStatus { initial, loading, success, failure }

class IncCategoriesState extends Equatable {
  const IncCategoriesState({
    this.status = IncCategoriesOverviewStatus.initial,
    this.incCategories = const [],
  });

  final IncCategoriesOverviewStatus status;
  final List<IncCategory> incCategories;

  IncCategoriesState copyWith({
    IncCategoriesOverviewStatus Function()? status,
    List<IncCategory> Function()? incCategories,
  }) {
    return IncCategoriesState(
      status: status != null ? status() : this.status,
      incCategories:
          incCategories != null ? incCategories() : this.incCategories,
    );
  }

  @override
  List<Object?> get props => [
        status,
        incCategories,
      ];
}
