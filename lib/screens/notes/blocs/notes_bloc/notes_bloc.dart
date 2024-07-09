import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:note_repository/note_repository.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc({required this.noteRepository}) : super(const NotesState()) {
    on<GetNotes>(_onGetNotes);
    on<CreateNote>(_onCreateNote);
    on<DeleteNote>(_onDeleteNote);
    on<UpdateNote>(_onUpdateNote);
  }

  final NoteRepository noteRepository;

  Future<void> _onGetNotes(
    GetNotes event,
    Emitter<NotesState> emit,
  ) async {
    emit(state.copyWith(status: () => NotesOverviewStatus.loading));

    await emit.forEach<List<Note>>(
      noteRepository.getNotes(),
      onData: (notes) => state.copyWith(
        status: () => NotesOverviewStatus.success,
        notes: () => notes,
      ),
      onError: (_, __) => state.copyWith(
        status: () => NotesOverviewStatus.failure,
      ),
    );
  }

  Future<void> _onCreateNote(
    CreateNote event,
    Emitter<NotesState> emit,
  ) async {
    try {
      // Perform the update operation
      await noteRepository.createNote(event.note);

      // Fetch updated list of notes from the stream
      await emit.forEach<List<Note>>(
        noteRepository.getNotes(),
        onData: (notes) => state.copyWith(
          status: () => NotesOverviewStatus.success,
          notes: () => notes,
        ),
        onError: (_, __) => state.copyWith(
          status: () => NotesOverviewStatus.failure,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: () => NotesOverviewStatus.failure,
      ));
    }
  }

  Future<void> _onDeleteNote(
    DeleteNote event,
    Emitter<NotesState> emit,
  ) async {
    try {
      // Perform the delete operation
      await noteRepository
          .deleteNote(event.noteId); // delete only required note

      // Fetch updated list of notes from the stream
      await emit.forEach<List<Note>>(
        noteRepository.getNotes(), // Use the Stream returned by getNotes
        onData: (notes) => state.copyWith(
          status: () => NotesOverviewStatus.success,
          notes: () => notes,
        ),
        onError: (_, __) => state.copyWith(
          status: () => NotesOverviewStatus.failure,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: () => NotesOverviewStatus.failure,
      ));
    }
  }

  Future<void> _onUpdateNote(
    UpdateNote event,
    Emitter<NotesState> emit,
  ) async {
    try {
      // Perform the update operation
      await noteRepository.updateNote(event.note);

      // Fetch updated list of notes from the stream
      await emit.forEach<List<Note>>(
        noteRepository.getNotes(),
        onData: (notes) => state.copyWith(
          status: () => NotesOverviewStatus.success,
          notes: () => notes,
        ),
        onError: (_, __) => state.copyWith(
          status: () => NotesOverviewStatus.failure,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: () => NotesOverviewStatus.failure,
      ));
    }
  }
}
