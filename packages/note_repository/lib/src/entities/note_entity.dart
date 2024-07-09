import 'package:cloud_firestore/cloud_firestore.dart';

class NoteEntity {
  String noteId;
  String userId; // Add userId field
  String title;
  String text;
  DateTime createdAt;
  DateTime updatedAt;

  NoteEntity({
    required this.noteId,
    required this.userId,
    required this.title,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, Object?> toDocument() {
    return {
      'noteId': noteId,
      'userId': userId, // Include userId in the document
      'title' : title,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt), // Convert DateTime to Timestamp
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  static NoteEntity fromDocument(Map<String, dynamic> doc) {
    return NoteEntity(
      noteId: doc['noteId'],
      userId: doc['userId'], // Extract userId from document
      title: doc['title'],
      text: doc['text'],
      createdAt: (doc['createdAt'] as Timestamp).toDate(), 
      updatedAt: (doc['updatedAt'] as Timestamp).toDate(), 
    );
  }
}

