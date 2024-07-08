part of 'create_note_bloc.dart';

sealed class CreateNoteEvent extends Equatable {
  const CreateNoteEvent();

  @override
  List<Object> get props => [];
}

class CreateNote extends CreateNoteEvent{
  final Note note;

  const CreateNote(this.note);
  
  @override
  List<Object> get props => [note];
}
