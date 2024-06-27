import 'package:expense_repository/expense_repository.dart';

class Expense {
  final String expenseId;
  final String userId; // Add userId field
  final ExpCategory category;
  final DateTime date;
  final int amount;

  const Expense({
    required this.expenseId,
    required this.userId, // Add userId to the constructor
    required this.category,
    required this.date,
    required this.amount,
  });

  Expense.empty(this.expenseId)
      : userId = '',
        category = ExpCategory.empty(''),
        date = DateTime.now(),
        amount = 0;

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      expenseId: expenseId,
      userId: userId, // Pass userId to ExpenseEntity
      category: category,
      date: date,
      amount: amount,
    );
  }

  static Expense fromEntity(ExpenseEntity entity) {
    return Expense(
      expenseId: entity.expenseId,
      userId: entity.userId, // Assign userId from ExpenseEntity
      category: entity.category,
      date: entity.date,
      amount: entity.amount,
    );
  }

  @override
  String toString() {
    return 'Expense(expenseId: $expenseId, userId: $userId, category: $category, date: $date, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Expense &&
        other.expenseId == expenseId &&
        other.userId == userId &&
        other.category == category &&
        other.date == date &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return Object.hash(expenseId, userId, category, date, amount);
  }

  Expense copyWith({
    String? expenseId,
    String? userId,
    ExpCategory? category,
    DateTime? date,
    int? amount,
  }) {
    return Expense(
      expenseId: expenseId ?? this.expenseId,
      userId: userId ?? this.userId,
      category: category ?? this.category,
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
