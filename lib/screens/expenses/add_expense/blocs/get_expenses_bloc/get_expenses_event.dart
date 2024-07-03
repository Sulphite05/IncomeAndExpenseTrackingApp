part of 'get_expenses_bloc.dart';

sealed class GetExpensesEvent extends Equatable {
  const GetExpensesEvent();

  @override
  List<Object?> get props => [];
}

class GetExpenses extends GetExpensesEvent {
  final String? categoryId;

  const GetExpenses({this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class DeleteExpense extends GetExpensesEvent {
  final String expenseId;
  final String categoryId;

  const DeleteExpense(this.expenseId, this.categoryId);

  @override
  List<Object> get props => [expenseId, categoryId];
}

class UpdateExpense extends GetExpensesEvent {
  final Expense expense;
  final String categoryId;

  const UpdateExpense(this.expense, this.categoryId);

  @override
  List<Object> get props => [expense, categoryId];
}
