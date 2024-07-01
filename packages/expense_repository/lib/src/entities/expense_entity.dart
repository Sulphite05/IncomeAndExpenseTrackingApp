import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseEntity {
  String expenseId;
  String userId; // Add userId field
  String categoryId;
  String name;
  DateTime date;
  int amount;

  ExpenseEntity({
    required this.expenseId,
    required this.userId,
    required this.categoryId,
    required this.name,
    required this.date,
    required this.amount,
  });

  Map<String, Object?> toDocument() {
    return {
      'expenseId': expenseId,
      'userId': userId, // Include userId in the document
      'categoryId': categoryId,
      'name': name,
      'date': Timestamp.fromDate(date), // Convert DateTime to Timestamp
      'amount': amount,
    };
  }

  static ExpenseEntity fromDocument(Map<String, dynamic> doc) {
    return ExpenseEntity(
      expenseId: doc['expenseId'],
      userId: doc['userId'], // Extract userId from document
      categoryId: doc['categoryId'],
      name: doc['name'],
      date: (doc['date'] as Timestamp).toDate(),
      amount: doc['amount'],
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expense_repository/src/entities/entities.dart';
// import '../models/models.dart';

// class ExpenseEntity {
//   String expenseId;
//   categoryId categoryId;
//   DateTime date;
//   int amount;

//   ExpenseEntity({
//     required this.expenseId,
//     required this.categoryId,
//     required this.date,
//     required this.amount,
//   });

//   Map<String, Object?> toDocument() {
//     return {
//       'expenseId': expenseId,
//       'categoryId': categoryId.toEntity().toDocument(),
//       'date': date,
//       'amount': amount,
//     };
//   }

//   static ExpenseEntity fromDocument(Map<String, dynamic> doc) {
//     return ExpenseEntity(
//       expenseId: doc['expenseId'],
//       categoryId:
//           categoryId.fromEntity(categoryIdEntity.fromDocument(doc['categoryId'])),
//       date: (doc['date'] as Timestamp).toDate(),
//       amount: doc['amount'],
//     );
//   }
// }
