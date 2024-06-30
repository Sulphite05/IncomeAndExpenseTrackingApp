import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'get_expenses_event.dart';
part 'get_expenses_state.dart';

class GetExpensesBloc extends Bloc<GetExpensesEvent, GetExpensesState> {
  GetExpensesBloc({required this.expenseRepository})
      : super(const GetExpensesState()) {
    on<GetExpenses>(_onGetExpenses);
  }

  final ExpenseRepository expenseRepository;

  Future<void> _onGetExpenses(
    GetExpenses event,
    Emitter<GetExpensesState> emit,
  ) async {
    emit(state.copyWith(status: () => ExpensesOverviewStatus.loading));

    await emit.forEach<List<Expense>>(
      expenseRepository.getExpenses(),
      onData: (expenses) => state.copyWith(
        status: () => ExpensesOverviewStatus.success,
        expenses: () => expenses,
      ),
      onError: (_, __) => state.copyWith(
        status: () => ExpensesOverviewStatus.failure,
      ),
    );
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
