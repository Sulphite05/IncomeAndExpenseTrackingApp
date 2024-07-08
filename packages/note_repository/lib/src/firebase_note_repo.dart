import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_repository/note_repository.dart';

class FirebaseNoteRepo implements NoteRepository {
  final noteCollection = FirebaseFirestore.instance.collection('notes');

  
  @override
  Stream<List<Note>> getNotes() async* {
    try {
        String userId = FirebaseAuth.instance.currentUser!.uid;
        yield await noteCollection
            .where('userId', isEqualTo: userId) // Filter by userId
            .get()
            .then((value) => value.docs
                .map((e) =>
                    Note.fromEntity(NoteEntity.fromDocument(e.data())))
                .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateNote(Note note) async {
    try {
      // Update the expense in the database
      await noteCollection
          .doc(note.noteId)
          .update(note.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> deleteNote(String noteId) async {
    try {
      await noteCollection.doc(noteId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  
  @override
  Future<void> createNote(Note note) async {
    try {
      await noteCollection
          .doc(note.noteId)
          .set(note.toEntity().toDocument()); // Pass userId to toDocument
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

}
