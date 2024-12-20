part of 'incomes_bloc.dart';

enum IncomesOverviewStatus { initial, loading, success, failure }

class IncomesState extends Equatable {
  const IncomesState({
    this.status = IncomesOverviewStatus.initial,
    this.incomes = const [],
  });

  final IncomesOverviewStatus status;
  final List<Income> incomes;

  IncomesState copyWith({
    IncomesOverviewStatus Function()? status,
    List<Income> Function()? incomes,
  }) {
    return IncomesState(
      status: status != null ? status() : this.status,
      incomes: incomes != null ? incomes() : this.incomes,
    );
  }

  @override
  List<Object?> get props => [
        status,
        incomes,
      ];
}

// part of 'get_expenses_bloc.dart';



// sealed class GetIncomesState extends Equatable {
//   const GetIncomesState();

//   @override
//   List<Object> get props => [];
// }

// final class GetIncomesInitial extends GetIncomesState {}

// final class GetIncomesFailure extends GetIncomesState {}

// final class GetIncomesLoading extends GetIncomesState {}

// final class GetIncomesSuccess extends GetIncomesState {
//   final List<Income> incomes;

//   const GetIncomesSuccess(this.incomes);

//   @override
//   List<Object> get props => [expenses];
// }
