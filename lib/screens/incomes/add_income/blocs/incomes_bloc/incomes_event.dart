part of 'incomes_bloc.dart';

sealed class GetIncomesEvent extends Equatable {
  const GetIncomesEvent();

  @override
  List<Object?> get props => [];
}

class GetIncomes extends GetIncomesEvent {
  final String? incCategoryId;
  final DateTime? startDate;
  final DateTime? endDate;

  const GetIncomes({this.incCategoryId, this.startDate, this.endDate});

  @override
  List<Object?> get props => [incCategoryId, startDate, endDate];
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
