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
      String userId = FirebaseAuth.instance.currentUser!.uid;
      // Check for existing categories with the same name, icon, or color
      final querySnapshot = await categoryCollection
          .where('name', isEqualTo: category.name)
          .where('userId', isEqualTo: userId)
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

  @override
  Stream<List<ExpCategory>> getCategories({String? categoryId}) async* {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Query query = categoryCollection;

      if (categoryId != null) {
        query = query.where('categoryId', isEqualTo: categoryId);
      } else {
        query = query.where('userId', isEqualTo: userId);
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
      final categorySnapshot = await categoryCollection.doc(categoryId).get();
      final categoryData = categorySnapshot.data();
      if (categoryData != null) {
        final category = ExpCategory.fromEntity(
            ExpCategoryEntity.fromDocument(categoryData));
        if (category.totalExpenses == 0) {
          await categoryCollection.doc(categoryId).delete();
        } else {
          throw Exception('The category is not empty!');
        }
      } else {
        throw Exception('Category not found!');
      }
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

      // Update the category's total amount
      final categorySnapshot =
          await categoryCollection.doc(expense.categoryId).get();
      final categoryData = categorySnapshot.data();
      if (categoryData != null) {
        final category = ExpCategory.fromEntity(
            ExpCategoryEntity.fromDocument(categoryData));
        category.totalExpenses += expense.amount;
        await updateCategory(category);
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
      {String? categoryId, DateTime? startDate, DateTime? endDate}) async* {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      if (categoryId != null) {
        yield await expenseCollection
            .where('categoryId',
                isEqualTo:
                    categoryId) // Filter by categoryId; won't be available for other users
            .get()
            .then((value) => value.docs
                .map((e) =>
                    Expense.fromEntity(ExpenseEntity.fromDocument(e.data())))
                .toList());
      } else if (startDate != null && endDate != null) {
        yield await expenseCollection
            .where('userId', isEqualTo: userId)
            .where('date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
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

  @override
  Future<void> updateExpense(Expense expense) async {
    try {
      // Get the current expense from the database
      final expenseSnapshot =
          await expenseCollection.doc(expense.expenseId).get();
      final expenseData = expenseSnapshot.data();
      if (expenseData == null) {
        throw Exception('Expense not found');
      }
      final currentExpense =
          Expense.fromEntity(ExpenseEntity.fromDocument(expenseData));

      // Calculate the difference between the new and old expense amounts
      final amountDifference = expense.amount - currentExpense.amount;

      // Update the category's total amount
      final categorySnapshot =
          await categoryCollection.doc(expense.categoryId).get();
      final categoryData = categorySnapshot.data();
      if (categoryData != null) {
        final category = ExpCategory.fromEntity(
            ExpCategoryEntity.fromDocument(categoryData));
        category.totalExpenses += amountDifference;
        await updateCategory(category);
      }

      // Update the expense in the database
      await expenseCollection
          .doc(expense.expenseId)
          .update(expense.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> deleteExpense(String expenseId) async {
    try {
      // Get the expense details to fetch the amount and categoryId
      final expenseSnapshot = await expenseCollection.doc(expenseId).get();
      final expenseData = expenseSnapshot.data();
      if (expenseData == null) {
        throw Exception('Expense not found');
      }
      final expense =
          Expense.fromEntity(ExpenseEntity.fromDocument(expenseData));

      // Delete the expense
      await expenseCollection.doc(expenseId).delete();

      // Update the category's total amount
      final categorySnapshot =
          await categoryCollection.doc(expense.categoryId).get();
      final categoryData = categorySnapshot.data();
      if (categoryData != null) {
        final category = ExpCategory.fromEntity(
            ExpCategoryEntity.fromDocument(categoryData));
        category.totalExpenses -= expense.amount;
        await updateCategory(category);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<ExpenseEntity>> fetchMonthlyExpenses(
      String userId, DateTime startDate, DateTime endDate) async {
    QuerySnapshot querySnapshot = await expenseCollection
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    return querySnapshot.docs
        .map((doc) =>
            ExpenseEntity.fromDocument(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
