part of 'get_incomes_bloc.dart';

sealed class GetIncomesEvent extends Equatable {
  const GetIncomesEvent();

  @override
  List<Object?> get props => [];
}

class GetIncomes extends GetIncomesEvent {
  final String? incCategoryId;

  const GetIncomes({this.incCategoryId});

  @override
  List<Object?> get props => [incCategoryId];
}

class DeleteIncome extends GetIncomesEvent {
  final String incomeId;
  final String incCategoryId;

  const DeleteIncome(this.incomeId, this.incCategoryId);

  @override
  List<Object> get props => [incomeId, incCategoryId];
}

class UpdateIncome extends GetIncomesEvent {
  final Income income;
  final String incCategoryId;

  const UpdateIncome(this.income, this.incCategoryId);

  @override
  List<Object> get props => [income, incCategoryId];
}
