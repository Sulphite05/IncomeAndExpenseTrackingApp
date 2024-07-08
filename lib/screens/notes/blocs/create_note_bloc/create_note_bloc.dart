import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_repository/note_repository.dart';

part 'create_note_event.dart';
part 'create_note_state.dart';

class CreateNoteBloc extends Bloc<CreateNoteEvent, CreateNoteState> {
  NoteRepository noteRepository;

  CreateNoteBloc({required this.noteRepository}) : super(CreateNoteInitial()) {  
    on<CreateNote>((event, emit) async {
      emit(CreateNoteLoading());
      try{
        await noteRepository.createNote(event.note);
        emit(CreateNoteSuccess());
      } catch(e){
        emit(CreateNoteFailure(e.toString()));
      }
    });
  }
}