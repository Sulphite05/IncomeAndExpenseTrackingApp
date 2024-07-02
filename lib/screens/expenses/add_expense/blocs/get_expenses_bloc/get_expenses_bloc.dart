import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'get_expenses_event.dart';
part 'get_expenses_state.dart';

class GetExpensesBloc extends Bloc<GetExpensesEvent, GetExpensesState> {
  GetExpensesBloc({required this.expenseRepository})
      : super(const GetExpensesState()) {
    on<GetExpenses>(_onGetExpenses);
    on<DeleteExpense>(_onDeleteExpense);
  }

  final ExpenseRepository expenseRepository;

  Future<void> _onGetExpenses(
    GetExpenses event,
    Emitter<GetExpensesState> emit,
  ) async {
    emit(state.copyWith(status: () => ExpensesOverviewStatus.loading));

    await emit.forEach<List<Expense>>(
      expenseRepository.getExpenses(
        userId: event.userId,
        categoryId: event.categoryId,
      ),
      onData: (expenses) => state.copyWith(
        status: () => ExpensesOverviewStatus.success,
        expenses: () => expenses,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ExpensesOverviewStatus.failure,
      ),
    );
  }

  Future<void> _onDeleteExpense(
    DeleteExpense event,
    Emitter<GetExpensesState> emit,
  ) async {
    try {
      // Perform the delete operation
      await expenseRepository.deleteExpense(event.expenseId); // delete only required expense

      // Fetch updated list of expenses from the stream
      await emit.forEach<List<Expense>>(
        expenseRepository
            .getExpenses(
            categoryId: event.categoryId,   // store back expenses of the same category
            ), // Use the Stream returned by getExpenses
        onData: (expenses) => state.copyWith(
          status: () => ExpensesOverviewStatus.success,
          expenses: () => expenses,
        ),
        onError: (_, __) => state.copyWith(
          status: () => ExpensesOverviewStatus.failure,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: () => ExpensesOverviewStatus.failure,
      ));
    }
  }
}
// (event, emit) async {
//       emit(GetExpensesLoading());
//       try {
//         List<Expense> expenses = await expenseRepository.getExpenses();
//         emit(GetExpensesSuccess(expenses));
//       } catch (e) {
//         emit(GetExpensesFailure());
//       }
//     }
