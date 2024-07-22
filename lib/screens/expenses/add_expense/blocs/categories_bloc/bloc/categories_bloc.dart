import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc({required this.expenseRepository})
      : super(const CategoriesState()) {
    on<GetCategories>(_onGetCategories);
    on<DeleteCategory>(_onDeleteCategory);
    on<CreateCategory>(_onCreateCategory);
  }

  final ExpenseRepository expenseRepository;

  Future<void> _onCreateCategory(
    CreateCategory event,
    Emitter<CategoriesState> emit,
  ) async {
    try {
      // Perform the delete operation
      await expenseRepository
          .createCategory(event.category); // delete only required expense

      // Fetch updated list of expenses from the stream
      await emit.forEach<List<ExpCategory>>(
        expenseRepository
            .getCategories(), // Use the Stream returned by getExpenses
        onData: (categories) => state.copyWith(
          status: () => CategoriesOverviewStatus.success,
          categories: () => categories,
        ),
        onError: (_, __) => state.copyWith(
          status: () => CategoriesOverviewStatus.failure,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: () => CategoriesOverviewStatus.failure,
      ));
    }
  }

  Future<void> _onGetCategories(
    GetCategories event,
    Emitter<CategoriesState> emit,
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

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoriesState> emit,
  ) async {
    try {
      // Perform the delete operation
      await expenseRepository
          .deleteCategory(event.categoryId); // delete only required expense

      // Fetch updated list of expenses from the stream
      await emit.forEach<List<ExpCategory>>(
        expenseRepository
            .getCategories(), // Use the Stream returned by getExpenses
        onData: (categories) => state.copyWith(
          status: () => CategoriesOverviewStatus.success,
          categories: () => categories,
        ),
        onError: (_, __) => state.copyWith(
          status: () => CategoriesOverviewStatus.failure,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: () => CategoriesOverviewStatus.failure,
      ));
    }
  }
}
