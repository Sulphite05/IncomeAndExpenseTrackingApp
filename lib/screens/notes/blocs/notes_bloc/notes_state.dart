part of 'notes_bloc.dart';

enum NotesOverviewStatus { initial, loading, success, failure }

class NotesState extends Equatable {
  const NotesState({
    this.status = NotesOverviewStatus.initial,
    this.notes = const [],
  });

  final NotesOverviewStatus status;
  final List<Note> notes;

  NotesState copyWith({
    NotesOverviewStatus Function()? status,
    List<Note> Function()? notes,
  }) {
    return NotesState(
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
