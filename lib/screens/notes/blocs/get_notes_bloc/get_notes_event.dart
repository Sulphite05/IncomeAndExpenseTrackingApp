part of 'get_notes_bloc.dart';

sealed class GetNotesEvent extends Equatable {
  const GetNotesEvent();

  @override
  List<Object?> get props => [];
}

class GetNotes extends GetNotesEvent {
}

class DeleteNote extends GetNotesEvent {
  final String noteId;

  const DeleteNote(this.noteId);

  @override
  List<Object> get props => [noteId];
}

class UpdateNote extends GetNotesEvent {
  final Note note;

  const UpdateNote(this.note);

  @override
  List<Object> get props => [note];
}
