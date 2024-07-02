import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'get_categories_event.dart';
part 'get_categories_state.dart';

class GetCategoriesBloc extends Bloc<GetCategoriesEvent, GetCategoriesState> {
  GetCategoriesBloc({required this.expenseRepository})
      : super(const GetCategoriesState()) {
    on<GetCategories>(_onGetCategories);
    on<DeleteCategory>(_onDeleteCategory);
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

    Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<GetCategoriesState> emit,
  ) async {
    try {
      // Perform the delete operation
      await expenseRepository
          .deleteCategory(event.categoryId); // delete only required expense

      // Fetch updated list of expenses from the stream
      await emit.forEach<List<ExpCategory>>(
        expenseRepository.getCategories(
          categoryId:
              event.categoryId, // store back expenses of the same category
        ), // Use the Stream returned by getExpenses
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


