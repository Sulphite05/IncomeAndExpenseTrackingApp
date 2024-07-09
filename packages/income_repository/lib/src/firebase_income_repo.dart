import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:income_repository/income_repository.dart';

class FirebaseIncomeRepo implements IncomeRepository {
  final categoryCollection =
      FirebaseFirestore.instance.collection('inc_categories');
  final incomeCollection = FirebaseFirestore.instance.collection('incomes');

  @override
  Future<void> createCategory(IncCategory category) async {
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
  Stream<List<IncCategory>> getCategories({String? categoryId}) async* {
    // 2 possibilities... sb fetch krwana hai, koi specific record fetch krwana hai
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      Query query = categoryCollection;

      if (categoryId != null) {
        query = query.where('categoryId', isEqualTo: categoryId);
      } else {
        query = query.where('userId', isEqualTo: userId);
      }

      yield await query.get().then((value) => value.docs
          .map((e) => IncCategory.fromEntity(
              IncCategoryEntity.fromDocument(e.data() as Map<String, dynamic>)))
          .toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateCategory(IncCategory category) async {
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
        final category = IncCategory.fromEntity(
            IncCategoryEntity.fromDocument(categoryData));
        if (category.totalIncomes == 0) {
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
  Future<void> createIncome(Income income) async {
    try {
      if (income.categoryId == '') {
        throw Exception('Please select a category.');
      }

      if (income.amount <= 0) {
        throw Exception('Please enter a valid amount.');
      }

      // Update the category's total amount
      final categorySnapshot =
          await categoryCollection.doc(income.categoryId).get();
      final categoryData = categorySnapshot.data();
      if (categoryData != null) {
        final category = IncCategory.fromEntity(
            IncCategoryEntity.fromDocument(categoryData));
        category.totalIncomes += income.amount;
        await updateCategory(category);
      }

      await incomeCollection
          .doc(income.incomeId)
          .set(income.toEntity().toDocument()); // Pass userId to toDocument
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Stream<List<Income>> getIncomes(
      {String? categoryId, DateTime? startDate, DateTime? endDate}) async* {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      if (categoryId != null) {
        yield await incomeCollection
            .where('categoryId',
                isEqualTo:
                    categoryId) // Filter by categoryId; won't be available for other users
            .get()
            .then((value) => value.docs
                .map((e) =>
                    Income.fromEntity(IncomeEntity.fromDocument(e.data())))
                .toList());
      } else if (startDate != null && endDate != null) {
        yield await incomeCollection
            .where('userId', isEqualTo: userId)
            .where('date',
                isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('date',
                isLessThanOrEqualTo: Timestamp.fromDate(
                    endDate)) // Filter by categoryId; won't be available for other users
            .get()
            .then((value) => value.docs
                .map((e) =>
                    Income.fromEntity(IncomeEntity.fromDocument(e.data())))
                .toList());
      } else {
        yield await incomeCollection
            .where('userId', isEqualTo: userId) // Filter by userId
            .get()
            .then((value) => value.docs
                .map((e) =>
                    Income.fromEntity(IncomeEntity.fromDocument(e.data())))
                .toList());
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> updateIncome(Income income) async {
    try {
      // Get the current expense from the database
      final incomeSnapshot = await incomeCollection.doc(income.incomeId).get();
      final incomeData = incomeSnapshot.data();
      if (incomeData == null) {
        throw Exception('Expense not found');
      }
      final currentIncome =
          Income.fromEntity(IncomeEntity.fromDocument(incomeData));

      // Calculate the difference between the new and old expense amounts
      final amountDifference = income.amount - currentIncome.amount;

      // Update the category's total amount
      final categorySnapshot =
          await categoryCollection.doc(income.categoryId).get();
      final categoryData = categorySnapshot.data();
      if (categoryData != null) {
        final category = IncCategory.fromEntity(
            IncCategoryEntity.fromDocument(categoryData));
        category.totalIncomes += amountDifference;
        await updateCategory(category);
      }

      // Update the expense in the database
      await incomeCollection
          .doc(income.incomeId)
          .update(income.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> deleteIncome(String incomeId) async {
    try {
      // Get the expense details to fetch the amount and categoryId
      final incomeSnapshot = await incomeCollection.doc(incomeId).get();
      final incomeData = incomeSnapshot.data();
      if (incomeData == null) {
        throw Exception('Income not found');
      }
      final income = Income.fromEntity(IncomeEntity.fromDocument(incomeData));

      // Delete the expense
      await incomeCollection.doc(incomeId).delete();

      // Update the category's total amount
      final categorySnapshot =
          await categoryCollection.doc(income.categoryId).get();
      final categoryData = categorySnapshot.data();
      if (categoryData != null) {
        final category = IncCategory.fromEntity(
            IncCategoryEntity.fromDocument(categoryData));
        category.totalIncomes -= income.amount;
        await updateCategory(category);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<IncomeEntity>> fetchMonthlyIncomes(
      String userId, DateTime startDate, DateTime endDate) async {
    QuerySnapshot querySnapshot = await incomeCollection
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    return querySnapshot.docs
        .map((doc) =>
            IncomeEntity.fromDocument(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
