import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_repository/expense_repository.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  final categoryCollection =
      FirebaseFirestore.instance.collection('exp_categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');

  @override
  Future<void> createCategory(ExpCategory category) async {
    try {
      await categoryCollection
          .doc(category.categoryId)
          .set(category.toEntity().toDocument()); // Pass userId to toDocument
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<ExpCategory>> getCategory() async {
    try {
      String userId =
          FirebaseAuth.instance.currentUser!.uid; // Get current user's userId

      return categoryCollection
          .where('userId', isEqualTo: userId) // Filter by userId
          .get()
          .then((value) => value.docs
              .map((e) => ExpCategory.fromEntity(
                  ExpCategoryEntity.fromDocument(e.data())))
              .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateCategory(ExpCategory category) async {
    try {
      await categoryCollection
          .doc(category.categoryId)
          .update(category.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    try {
      await categoryCollection.doc(categoryId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }



  @override
  Future<void> createExpense(Expense expense) async {
    try {
      await expenseCollection
          .doc(expense.expenseId)
          .set(expense.toEntity().toDocument()); // Pass userId to toDocument
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Stream<List<Expense>> getExpenses() async* {
    try {
      String userId =
          FirebaseAuth.instance.currentUser!.uid; // Get current user's userId

      yield await expenseCollection
          .where('userId', isEqualTo: userId) // Filter by userId
          .get()
          .then((value) => value.docs
              .map((e) =>
                  Expense.fromEntity(ExpenseEntity.fromDocument(e.data())))
              .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  
  // @override
  // Future<List<Expense>> getExpenses() async {
  //   try {
  //     String userId =
  //         FirebaseAuth.instance.currentUser!.uid; // Get current user's userId

  //     return await expenseCollection
  //         .where('userId', isEqualTo: userId) // Filter by userId
  //         .get()
  //         .then((value) => value.docs
  //             .map((e) =>
  //                 Expense.fromEntity(ExpenseEntity.fromDocument(e.data())))
  //             .toList());
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }

  @override
  Future<void> updateExpense(Expense expense) async {
    try {
      await categoryCollection
          .doc(expense.expenseId)
          .update(expense.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    try {
      await expenseCollection.doc(expenseId).delete();
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}

// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expense_repository/expense_repository.dart';

// class FirebaseExpenseRepo implements ExpenseRepository {
//   final categoryCollection =
//       FirebaseFirestore.instance.collection('exp_categories');
//   final expenseCollection = FirebaseFirestore.instance.collection('expenses');

//   @override
//   Future<void> createCategory(Category category) async {
//     try {
//       await categoryCollection
//           .doc(category
//               .categoryId) // adds additional security layer for clarity expenseRepository is an abstract class
//           .set(category.toEntity().toDocument());
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   @override
//   Future<List<Category>>
//       getCategory() // adds additional security layer for clarity expenseRepository is an abstract class
//   async {
//     try {
//       return await categoryCollection.get().then((value) => value.docs
//           .map((e) =>
//               Category.fromEntity(ExpCategoryEntity.fromDocument(e.data())))
//           .toList());
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   @override
//   Future<void> createExpense(Expense expense) async {
//     try {
//       await expenseCollection
//           .doc(expense
//               .expenseId) // adds additional security layer for clarity expenseRepository is an abstract class
//           .set(expense.toEntity().toDocument());
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }

//   @override
//   Future<List<Expense>>
//       getExpenses() // adds additional security layer for clarity expenseRepository is an abstract class
//   async {
//     try {
//       return await expenseCollection.get().then((value) => value.docs
//           .map((e) => Expense.fromEntity(ExpenseEntity.fromDocument(e.data())))
//           .toList());
//     } catch (e) {
//       log(e.toString());
//       rethrow;
//     }
//   }
// }
