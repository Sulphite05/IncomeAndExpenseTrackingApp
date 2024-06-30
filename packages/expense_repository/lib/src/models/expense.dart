import 'package:expense_repository/expense_repository.dart';

class Expense {
  final String expenseId;
  final String userId; // Add userId field
  final String categoryId;
  final DateTime date;
  final int amount;

  const Expense({
    required this.expenseId,
    required this.userId, // Add userId to the constructor
    required this.categoryId,
    required this.date,
    required this.amount,
  });

  Expense.empty(this.expenseId)
      : userId = '',
        categoryId = '',
        date = DateTime.now(),
        amount = 0;

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      expenseId: expenseId,
      userId: userId, // Pass userId to ExpenseEntity
      categoryId: categoryId,
      date: date,
      amount: amount,
    );
  }

  static Expense fromEntity(ExpenseEntity entity) {
    return Expense(
      expenseId: entity.expenseId,
      userId: entity.userId, // Assign userId from ExpenseEntity
      categoryId: entity.categoryId,
      date: entity.date,
      amount: entity.amount,
    );
  }

  @override
  String toString() {
    return 'Expense(expenseId: $expenseId, userId: $userId, category: $categoryId, date: $date, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Expense &&
        other.expenseId == expenseId &&
        other.userId == userId &&
        other.categoryId == categoryId &&
        other.date == date &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return Object.hash(expenseId, userId, categoryId, date, amount);
  }

  Expense copyWith({
    String? expenseId,
    String? userId,
    String? categoryId,
    DateTime? date,
    int? amount,
  }) {
    return Expense(
      expenseId: expenseId ?? this.expenseId,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
    );
  }

}

// import 'package:expense_repository/expense_repository.dart';

// class Expense {
//   String expenseId;
//   Category category;
//   DateTime date;
//   int amount;

//   Expense({
//     required this.expenseId,
//     required this.category,
//     required this.date,
//     required this.amount,
//   });

//   static final empty = Expense(
//     expenseId: '',
//     category: Category.empty,
//     date: DateTime.now(),
//     amount: 0,
//   );

//   ExpenseEntity toEntity() {
//     return ExpenseEntity(
//       expenseId: expenseId,
//       category: category,
//       date: date,
//       amount: amount,
//     );
//   }

//   static Expense fromEntity(ExpenseEntity entity) {
//     return Expense(
//       expenseId: entity.expenseId,
//       category: entity.category,
//       date: entity.date,
//       amount: entity.amount,
//     );
//   }
// }
