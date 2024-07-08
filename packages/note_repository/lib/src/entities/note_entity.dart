import 'package:cloud_firestore/cloud_firestore.dart';

class NoteEntity {
  String noteId;
  String userId; // Add userId field
  String text;
  DateTime date;

  NoteEntity({
    required this.noteId,
    required this.userId,
    required this.text,
    required this.date,
  });

  Map<String, Object?> toDocument() {
    return {
      'noteId': noteId,
      'userId': userId, // Include userId in the document
      'text': text,
      'date': Timestamp.fromDate(date), // Convert DateTime to Timestamp
    };
  }

  static NoteEntity fromDocument(Map<String, dynamic> doc) {
    return NoteEntity(
      noteId: doc['noteId'],
      userId: doc['userId'], // Extract userId from document
      text: doc['text'],
      date: (doc['date'] as Timestamp).toDate(),
    );
  }
}

