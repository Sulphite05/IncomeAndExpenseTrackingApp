import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeEntity {
  String incomeId;
  String userId; // Add userId field
  String categoryId;
  String name;
  DateTime date;
  int amount;

  IncomeEntity({
    required this.incomeId,
    required this.userId,
    required this.categoryId,
    required this.name,
    required this.date,
    required this.amount,
  });

  Map<String, Object?> toDocument() {
    return {
      'incomeId': incomeId,
      'userId': userId, // Include userId in the document
      'categoryId': categoryId,
      'name': name,
      'date': Timestamp.fromDate(date), // Convert DateTime to Timestamp
      'amount': amount,
    };
  }

  static IncomeEntity fromDocument(Map<String, dynamic> doc) {
    return IncomeEntity(
      incomeId: doc['incomeId'],
      userId: doc['userId'], // Extract userId from document
      categoryId: doc['categoryId'],
      name: doc['name'],
      date: (doc['date'] as Timestamp).toDate(),
      amount: doc['amount'],
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:Income_repository/src/entities/entities.dart';
// import '../models/models.dart';

// class IncomeEntity {
//   String incomeId;
//   categoryId categoryId;
//   DateTime date;
//   int amount;

//   IncomeEntity({
//     required this.incomeId,
//     required this.categoryId,
//     required this.date,
//     required this.amount,
//   });

//   Map<String, Object?> toDocument() {
//     return {
//       'incomeId': incomeId,
//       'categoryId': categoryId.toEntity().toDocument(),
//       'date': date,
//       'amount': amount,
//     };
//   }

//   static IncomeEntity fromDocument(Map<String, dynamic> doc) {
//     return IncomeEntity(
//       incomeId: doc['incomeId'],
//       categoryId:
//           categoryId.fromEntity(categoryIdEntity.fromDocument(doc['categoryId'])),
//       date: (doc['date'] as Timestamp).toDate(),
//       amount: doc['amount'],
//     );
//   }
// }
