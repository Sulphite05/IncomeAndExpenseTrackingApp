import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:income_repository/income_repository.dart';

part 'get_icategories_event.dart';
part 'get_icategories_state.dart';

class GetIncCategoriesBloc extends Bloc<GetIncCategoriesEvent, GetIncCategoriesState> {
  GetIncCategoriesBloc({required this.incomeRepository})
      : super(const GetIncCategoriesState()) {
    on<GetIncCategories>(_onGetIncCategories);
    on<DeleteIncCategory>(_onDeleteIncCategory);
  }

  final IncomeRepository incomeRepository;

  Future<void> _onGetIncCategories(
    GetIncCategories event,
    Emitter<GetIncCategoriesState> emit,
  ) async {
    emit(state.copyWith(status: () => IncCategoriesOverviewStatus.loading));

    await emit.forEach<List<IncCategory>>(
      incomeRepository.getCategories(),
      onData: (categories) => state.copyWith(
        status: () => IncCategoriesOverviewStatus.success,
        incCategories: () => categories,
      ),
      onError: (_, __) => state.copyWith(
        status: () => IncCategoriesOverviewStatus.failure,
      ),
    );
  }

    Future<void> _onDeleteIncCategory(
    DeleteIncCategory event,
    Emitter<GetIncCategoriesState> emit,
  ) async {
    try {
      // Perform the delete operation
      await incomeRepository
          .deleteCategory(event.categoryId); // delete only required expense

      // Fetch updated list of expenses from the stream
      await emit.forEach<List<IncCategory>>(
        incomeRepository.getCategories(), // Use the Stream returned by getExpenses
        onData: (incCategories) => state.copyWith(
          status: () => IncCategoriesOverviewStatus.success,
          incCategories: () => incCategories,
        ),
        onError: (_, __) => state.copyWith(
          status: () => IncCategoriesOverviewStatus.failure,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: () => IncCategoriesOverviewStatus.failure,
      ));
    }
  }
}


