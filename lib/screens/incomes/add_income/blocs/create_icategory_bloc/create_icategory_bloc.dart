import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:income_repository/income_repository.dart';

part 'create_icategory_event.dart';
part 'create_icategory_state.dart';

class CreateIncCategoryBloc
    extends Bloc<CreateIncCategoryEvent, CreateIncCategoryState> {
  final IncomeRepository incomeRepository;

  CreateIncCategoryBloc({required this.incomeRepository}) : super(CreateIncCategoryInitial()) {
    on<CreateIncCategory>((event, emit) async {
      emit(CreateIncCategoryLoading());
      try {
        await incomeRepository.createCategory(event.incCategory);
        emit(CreateIncCategorySuccess());
      } catch (e) {
        emit(CreateIncCategoryFailure(e.toString()));
      }
    });
  }
}
