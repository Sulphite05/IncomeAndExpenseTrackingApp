import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'get_categories_event.dart';
part 'get_categories_state.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  GetCategoriesBloc({required this.expenseRepository})
      : super(const GetCategoriesState()) {
    on<GetCategories>(_onGetCategories);
  }

  final ExpenseRepository expenseRepository;

  Future<void> _onGetCategories(
    GetCategories event,
    Emitter<GetCategoriesState> emit,
  ) async {
    emit(state.copyWith(status: () => CategoriesOverviewStatus.loading));

    await emit.forEach<List<ExpCategory>>(
      expenseRepository.getCategories(),
      onData: (categories) => state.copyWith(
        status: () => CategoriesOverviewStatus.success,
        categories: () => categories,
      ),
      onError: (_, __) => state.copyWith(
        status: () => CategoriesOverviewStatus.failure,
      ),
    );
  }
}


