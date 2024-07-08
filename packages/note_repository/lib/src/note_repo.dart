
import 'package:note_repository/note_repository.dart';

abstract class NoteRepository {

  // The CRUD Commands

  Future<void> createNote(Note note); // Create

  Stream<List<Note>> getNotes(); // Read All

  Future<void> updateNote(Note note); // Update

  Future<void> deleteNote(String noteId); // Delete
}
