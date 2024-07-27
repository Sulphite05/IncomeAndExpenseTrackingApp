part of 'incomes_bloc.dart';

sealed class IncomesEvent extends Equatable {
  const IncomesEvent();

  @override
  List<Object?> get props => [];
}

class CreateIncome extends IncomesEvent {
  final Income income;

  const CreateIncome(this.income);

  @override
  List<Object> get props => [income];
}


class GetIncomes extends IncomesEvent {
  final String? incCategoryId;
  final DateTime? startDate;
  final DateTime? endDate;

  const GetIncomes({this.incCategoryId, this.startDate, this.endDate});

  @override
  List<Object?> get props => [incCategoryId, startDate, endDate];
}

class DeleteIncome extends IncomesEvent {
  final String incomeId;
  final String incCategoryId;

  const DeleteIncome(this.incomeId, this.incCategoryId);

  @override
  List<Object> get props => [incomeId, incCategoryId];
}

class UpdateIncome extends IncomesEvent {
  final Income income;
  final String incCategoryId;

  const UpdateIncome(this.income, this.incCategoryId);

  @override
  List<Object> get props => [income, incCategoryId];
}
