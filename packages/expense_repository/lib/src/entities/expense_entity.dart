import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/src/entities/entities.dart';
import '../models/models.dart';

class ExpenseEntity {
  String expenseId;
  String userId; // Add userId field
  ExpCategory category;
  DateTime date;
  int amount;

  ExpenseEntity({
    required this.expenseId,
    required this.userId,
    required this.category,
    required this.date,
    required this.amount,
  });

  Map<String, Object?> toDocument() {
    return {
      'expenseId': expenseId,
      'userId': userId, // Include userId in the document
      'category': category.toEntity().toDocument(),
      'date': Timestamp.fromDate(date), // Convert DateTime to Timestamp
      'amount': amount,
    };
  }

  static ExpenseEntity fromDocument(Map<String, dynamic> doc) {
    return ExpenseEntity(
      expenseId: doc['expenseId'],
      userId: doc['userId'], // Extract userId from document
      category: ExpCategory.fromEntity(
          ExpCategoryEntity.fromDocument(doc['category'])),
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
//   Category category;
//   DateTime date;
//   int amount;

//   ExpenseEntity({
//     required this.expenseId,
//     required this.category,
//     required this.date,
//     required this.amount,
//   });

//   Map<String, Object?> toDocument() {
//     return {
//       'expenseId': expenseId,
//       'category': category.toEntity().toDocument(),
//       'date': date,
//       'amount': amount,
//     };
//   }

//   static ExpenseEntity fromDocument(Map<String, dynamic> doc) {
//     return ExpenseEntity(
//       expenseId: doc['expenseId'],
//       category:
//           Category.fromEntity(CategoryEntity.fromDocument(doc['category'])),
//       date: (doc['date'] as Timestamp).toDate(),
//       amount: doc['amount'],
//     );
//   }
// }
