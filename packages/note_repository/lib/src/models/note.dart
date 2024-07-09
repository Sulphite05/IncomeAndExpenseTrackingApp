import 'package:note_repository/note_repository.dart';

class Note {
  final String noteId;
  final String userId;
  final String title;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Note({
    required this.noteId,
    required this.userId, // Add userId to the constructor
    required this.text,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  Note.empty(this.noteId)
      : userId = '',
        text = '',
        title = '',
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  NoteEntity toEntity() {
    return NoteEntity(
      noteId: noteId,
      userId: userId, // Pass userId to NoteEntity
      title: title,
      text: text,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static Note fromEntity(NoteEntity entity) {
    return Note(
      noteId: entity.noteId,
      userId: entity.userId, // Pass userId to NoteEntity
      title: entity.title,
      text: entity.text,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Note(noteId: $noteId, userId: $userId, text: $text, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.noteId == noteId &&
        other.userId == userId &&
        other.title == title &&
        other.text == text &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  
  }

  @override
  int get hashCode {
    return Object.hash(noteId, userId, title, text, createdAt, updatedAt);
  }

  Note copyWith({
    String? noteId,
    String? userId,
    String? title,
    String? text,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Note(
        noteId: noteId ?? this.noteId,
        userId: userId ?? this.userId,
        text: text ?? this.text, 
        title: title ?? this.title, 
        updatedAt: updatedAt ?? this.updatedAt, 
        createdAt: createdAt ?? this.createdAt,
        );
  }
}
