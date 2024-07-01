import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  final categoryCollection =
      FirebaseFirestore.instance.collection('exp_categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');

  @override
  Future<void> createCategory(ExpCategory category) async {
    try {
      // Check for existing categories with the same name, icon, or color
      final querySnapshot = await categoryCollection
          .where('name', isEqualTo: category.name)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw Exception('A category with the same name already exists.');
      }

      if (category.name == '') {
        throw Exception('Please enter a category name.');
      }

      if (category.icon == '') {
        throw Exception('Please select an icon.');
      }

      // If no existing category matches, proceed to create the new category
      await categoryCollection
          .doc(category.categoryId)
          .set(category.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  // @override
  // Future<List<ExpCategory>> getCategories() async {
  //   try {
  //     String userId =
  //         FirebaseAuth.instance.currentUser!.uid; // Get current user's userId

  //     return categoryCollection
  //         .where('userId', isEqualTo: userId) // Filter by userId
  //         .get()
  //         .then((value) => value.docs
  //             .map((e) => ExpCategory.fromEntity(
  //                 ExpCategoryEntity.fromDocument(e.data())))
  //             .toList());
  //   } catch (e) {
  //     log(e.toString());
  //     rethrow;
  //   }
  // }

  @override
  Stream<List<ExpCategory>> getCategories(
      {String? userId, String? categoryId}) async* {
    try {
      Query query = categoryCollection;

      if (userId != null) {
        query = query.where('userId', isEqualTo: userId);
      }

      if (categoryId != null) {
        query = query.where('categoryId', isEqualTo: categoryId);
      }
      yield await query.get().then((value) => value.docs
          .map((e) => ExpCategory.fromEntity(
              ExpCategoryEntity.fromDocument(e.data() as Map<String, dynamic>)))
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
      if (expense.categoryId == '') {
        throw Exception('Please select a category.');
      }

      if (expense.amount <= 0) {
        throw Exception('Please enter a valid amount.');
      }

      await expenseCollection
          .doc(expense.expenseId)
          .set(expense.toEntity().toDocument()); // Pass userId to toDocument
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Stream<List<Expense>> getExpenses(
      {String? userId, String? categoryId}) async* {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      if (categoryId != null) {
        yield await expenseCollection
            .where('categoryId', isEqualTo: categoryId) // Filter by userId
            .get()
            .then((value) => value.docs
                .map((e) =>
                    Expense.fromEntity(ExpenseEntity.fromDocument(e.data())))
                .toList());
      } else {
        yield await expenseCollection
            .where('userId', isEqualTo: userId) // Filter by userId
            .get()
            .then((value) => value.docs
                .map((e) =>
                    Expense.fromEntity(ExpenseEntity.fromDocument(e.data())))
                .toList());
      }
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
      await expenseCollection
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
