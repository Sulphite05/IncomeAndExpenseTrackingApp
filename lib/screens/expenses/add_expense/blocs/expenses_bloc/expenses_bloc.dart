import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'expenses_event.dart';
part 'expenses_state.dart';

class ExpensesBloc extends Bloc<ExpensesEvent, ExpensesState> {
  ExpensesBloc({required this.expenseRepository})
      : super(const ExpensesState()) {
    on<CreateExpense>(_onCreateExpense);
    on<GetExpenses>(_onGetExpenses);
    on<DeleteExpense>(_onDeleteExpense);
    on<UpdateExpense>(_onUpdateExpense);
  }

  final ExpenseRepository expenseRepository;

  Future<void> _onCreateExpense(
    CreateExpense event,
    Emitter<ExpensesState> emit,
  ) async {
    try {
      // Perform the delete operation
      await expenseRepository
          .createExpense(event.expense); // delete only required expense

      // Fetch updated list of expenses from the stream
      await emit.forEach<List<Expense>>(
        expenseRepository
            .getExpenses(), // Use the Stream returned by getExpenses
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

  Future<void> _onGetExpenses(
    GetExpenses event,
    Emitter<ExpensesState> emit,
  ) async {
    emit(state.copyWith(status: () => ExpensesOverviewStatus.loading));

    await emit.forEach<List<Expense>>(
      expenseRepository.getExpenses(
        categoryId: event.categoryId,
        startDate: event.startDate,
        endDate: event.endDate,
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
    Emitter<ExpensesState> emit,
  ) async {
    try {
      // Perform the delete operation
      await expenseRepository
          .deleteExpense(event.expenseId); // delete only required expense

      // Fetch updated list of expenses from the stream
      await emit.forEach<List<Expense>>(
        expenseRepository.getExpenses(
          categoryId:
              event.categoryId, // store back expenses of the same category
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

  Future<void> _onUpdateExpense(
    UpdateExpense event,
    Emitter<ExpensesState> emit,
  ) async {
    try {
      // Perform the update operation
      await expenseRepository.updateExpense(event.expense);

      // Fetch updated list of expenses from the stream
      await emit.forEach<List<Expense>>(
        expenseRepository.getExpenses(
          categoryId: event.categoryId, // Fetch expenses for the same category
        ),
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
