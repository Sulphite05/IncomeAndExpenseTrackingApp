import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:income_repository/income_repository.dart';

part 'incomes_event.dart';
part 'incomes_state.dart';

class IncomesBloc extends Bloc<IncomesEvent, IncomesState> {
  IncomesBloc({required this.incomeRepository}) : super(const IncomesState()) {
    on<CreateIncome>(_onCreateIncome);
    on<GetIncomes>(_onGetIncomes);
    on<DeleteIncome>(_onDeleteIncome);
    on<UpdateIncome>(_onUpdateIncome);
  }

  final IncomeRepository incomeRepository;

  Future<void> _onCreateIncome(
    CreateIncome event,
    Emitter<IncomesState> emit,
  ) async {
    try {
      // Perform the delete operation
      await incomeRepository
          .createIncome(event.income); // delete only required expense

      // Fetch updated list of expenses from the stream
      await emit.forEach<List<Income>>(
        incomeRepository.getIncomes(// store back expenses of the same category
            ), // Use the Stream returned by getIncomes
        onData: (incomes) => state.copyWith(
          status: () => IncomesOverviewStatus.success,
          incomes: () => incomes,
        ),
        onError: (_, __) => state.copyWith(
          status: () => IncomesOverviewStatus.failure,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: () => IncomesOverviewStatus.failure,
      ));
    }
  }

  Future<void> _onGetIncomes(
    GetIncomes event,
    Emitter<IncomesState> emit,
  ) async {
    emit(state.copyWith(status: () => IncomesOverviewStatus.loading));

    await emit.forEach<List<Income>>(
      incomeRepository.getIncomes(
        categoryId: event.incCategoryId,
        startDate: event.startDate,
        endDate: event.endDate,
      ),
      onData: (incomes) => state.copyWith(
        status: () => IncomesOverviewStatus.success,
        incomes: () => incomes,
      ),
      onError: (_, __) => state.copyWith(
        status: () => IncomesOverviewStatus.failure,
      ),
    );
  }

  Future<void> _onDeleteIncome(
    DeleteIncome event,
    Emitter<IncomesState> emit,
  ) async {
    try {
      // Perform the delete operation
      await incomeRepository
          .deleteIncome(event.incomeId); // delete only required expense

      // Fetch updated list of expenses from the stream
      await emit.forEach<List<Income>>(
        incomeRepository.getIncomes(
          categoryId:
              event.incCategoryId, // store back expenses of the same category
        ), // Use the Stream returned by getIncomes
        onData: (incomes) => state.copyWith(
          status: () => IncomesOverviewStatus.success,
          incomes: () => incomes,
        ),
        onError: (_, __) => state.copyWith(
          status: () => IncomesOverviewStatus.failure,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: () => IncomesOverviewStatus.failure,
      ));
    }
  }

  Future<void> _onUpdateIncome(
    UpdateIncome event,
    Emitter<IncomesState> emit,
  ) async {
    try {
      // Perform the update operation
      await incomeRepository.updateIncome(event.income);

      // Fetch updated list of expenses from the stream
      await emit.forEach<List<Income>>(
        incomeRepository.getIncomes(
          categoryId:
              event.incCategoryId, // Fetch expenses for the same category
        ),
        onData: (incomes) => state.copyWith(
          status: () => IncomesOverviewStatus.success,
          incomes: () => incomes,
        ),
        onError: (_, __) => state.copyWith(
          status: () => IncomesOverviewStatus.failure,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: () => IncomesOverviewStatus.failure,
      ));
    }
  }
}

// (event, emit) async {
//       emit(GetIncomesLoading());
//       try {
//         List<Expense> expenses = await incomeRepository.getIncomes();
//         emit(GetIncomesSuccess(expenses));
//       } catch (e) {
//         emit(GetIncomesFailure());
//       }
//     }
