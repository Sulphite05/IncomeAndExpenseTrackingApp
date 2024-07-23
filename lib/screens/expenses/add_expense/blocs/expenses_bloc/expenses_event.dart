part of 'expenses_bloc.dart';

sealed class ExpensesEvent extends Equatable {
  const ExpensesEvent();

  @override
  List<Object?> get props => [];
}

class CreateExpense extends ExpensesEvent {
  final Expense expense;

  const CreateExpense(this.expense);

  @override
  List<Object> get props => [expense];
}

class GetExpenses extends ExpensesEvent {
  final String? categoryId;
  final DateTime? startDate;
  final DateTime? endDate;

  const GetExpenses({this.categoryId, this.startDate, this.endDate});

  @override
  List<Object?> get props => [categoryId, startDate, endDate];
}

class DeleteExpense extends ExpensesEvent {
  final String expenseId;
  final String categoryId;

  const DeleteExpense(this.expenseId, this.categoryId);

  @override
  List<Object> get props => [expenseId, categoryId];
}

class UpdateExpense extends ExpensesEvent {
  final Expense expense;
  final String categoryId;

  const UpdateExpense(this.expense, this.categoryId);

  @override
  List<Object> get props => [expense, categoryId];
}
