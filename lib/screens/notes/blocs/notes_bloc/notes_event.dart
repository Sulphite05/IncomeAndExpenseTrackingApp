part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object?> get props => [];
}

class GetNotes extends NotesEvent {}

class CreateNote extends NotesEvent {
  final Note note;

  const CreateNote(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteNote extends NotesEvent {
  final String noteId;

  const DeleteNote(this.noteId);

  @override
  List<Object> get props => [noteId];
}

class UpdateNote extends NotesEvent {
  final Note note;

  const UpdateNote(this.note);

  @override
  List<Object> get props => [note];
}
