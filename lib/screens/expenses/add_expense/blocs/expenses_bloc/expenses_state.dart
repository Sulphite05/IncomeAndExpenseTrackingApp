part of 'expenses_bloc.dart';

enum ExpensesOverviewStatus { initial, loading, success, failure }

class GetExpensesState extends Equatable {
  const GetExpensesState({
    this.status = ExpensesOverviewStatus.initial,
    this.expenses = const [],
  });

  final ExpensesOverviewStatus status;
  final List<Expense> expenses;

  GetExpensesState copyWith({
    ExpensesOverviewStatus Function()? status,
    List<Expense> Function()? expenses,
  }) {
    return GetExpensesState(
      status: status != null ? status() : this.status,
      expenses: expenses != null ? expenses() : this.expenses,
    );
  }

  @override
  List<Object?> get props => [
        status,
        expenses,
      ];
}

// part of 'get_expenses_bloc.dart';



// sealed class GetExpensesState extends Equatable {
//   const GetExpensesState();

//   @override
//   List<Object> get props => [];
// }

// final class GetExpensesInitial extends GetExpensesState {}

// final class GetExpensesFailure extends GetExpensesState {}

// final class GetExpensesLoading extends GetExpensesState {}

// final class GetExpensesSuccess extends GetExpensesState {
//   final List<Expense> expenses;

//   const GetExpensesSuccess(this.expenses);

//   @override
//   List<Object> get props => [expenses];
// }
