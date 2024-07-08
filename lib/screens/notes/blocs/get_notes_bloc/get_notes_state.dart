part of 'get_notes_bloc.dart';

enum NotesOverviewStatus { initial, loading, success, failure }

class GetNotesState extends Equatable {
  const GetNotesState({
    this.status = NotesOverviewStatus.initial,
    this.notes = const [],
  });

  final NotesOverviewStatus status;
  final List<Note> notes;

  GetNotesState copyWith({
    NotesOverviewStatus Function()? status,
    List<Note> Function()? notes,
  }) {
    return GetNotesState(
      status: status != null ? status() : this.status,
      notes: notes != null ? notes() : this.notes,
    );
  }

  @override
  List<Object?> get props => [
        status,
        notes,
      ];
}

