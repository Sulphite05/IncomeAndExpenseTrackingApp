import 'package:expense_repository/expense_repository.dart';

class Expense {
  final String expenseId;
  final String userId; // Add userId field
  final String categoryId;
  final String name;
  final DateTime date;
  final int amount;

  const Expense({
    required this.expenseId,
    required this.userId, // Add userId to the constructor
    required this.categoryId,
    required this.name,
    required this.date,
    required this.amount,
  });

  Expense.empty(this.expenseId)
      : userId = '',
        categoryId = '',
        name = '',
        date = DateTime.now(),
        amount = 0;

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      expenseId: expenseId,
      userId: userId, // Pass userId to ExpenseEntity
      categoryId: categoryId,
      name: name,
      date: date,
      amount: amount,
    );
  }

  static Expense fromEntity(ExpenseEntity entity) {
    return Expense(
      expenseId: entity.expenseId,
      userId: entity.userId, // Assign userId from ExpenseEntity
      categoryId: entity.categoryId,
      name: entity.name,
      date: entity.date,
      amount: entity.amount,
    );
  }

  @override
  String toString() {
    return 'Expense(expenseId: $expenseId, userId: $userId, category: $categoryId, name: $name, date: $date, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Expense &&
        other.expenseId == expenseId &&
        other.userId == userId &&
        other.categoryId == categoryId &&
        other.name == name &&
        other.date == date &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return Object.hash(expenseId, userId, categoryId, name, date, amount);
  }

  Expense copyWith({
    String? expenseId,    // to make it immutable
    String? userId,
    String? categoryId,
    String? name,
    DateTime? date,
    int? amount,
  }) {
    return Expense(
      expenseId: expenseId ?? this.expenseId,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
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
