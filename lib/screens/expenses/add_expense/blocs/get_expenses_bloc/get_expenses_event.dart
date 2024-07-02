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
