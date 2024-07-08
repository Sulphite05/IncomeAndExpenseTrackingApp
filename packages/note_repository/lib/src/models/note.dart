import 'package:note_repository/note_repository.dart';

class Note{
  final String noteId;
  final String userId; // Add userId field
  final String text;
  final DateTime date;

  const Note({
    required this.noteId,
    required this.userId, // Add userId to the constructor
    required this.text,
    required this.date,
  });

  Note.empty(this.noteId)
      : userId = '',
        text = '',
        date = DateTime.now();

  NoteEntity toEntity() {
    return NoteEntity(
      noteId: noteId,
      userId: userId, // Pass userId to NoteEntity
      text: text,
      date: date,
    );
  }

  static Note fromEntity(NoteEntity entity) {
    return Note(
      noteId: entity.noteId,
      userId: entity.userId, // Assign userId from NoteEntity
      text: entity.text,
      date: entity.date,
    );
  }

  @override
  String toString() {
    return 'Note(noteId: $noteId, userId: $userId, text: $text, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note&&
        other.noteId == noteId &&
        other.userId == userId &&
        other.text == text &&
        other.date == date;
  }

  @override
  int get hashCode {
    return Object.hash(noteId, userId, text, date);
  }

  NotecopyWith({
    String? noteId,
    String? userId,
    String? text,
    DateTime? date,
  }) {
    return Note(
      noteId: noteId ?? this.noteId,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      date: date ?? this.date
    );
  }
}
