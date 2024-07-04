
import 'package:income_repository/income_repository.dart';

class Income {
  final String incomeId;
  final String userId; // Add userId field
  final String categoryId;
  final String name;
  final DateTime date;
  final int amount;

  const Income({
    required this.incomeId,
    required this.userId, // Add userId to the constructor
    required this.categoryId,
    required this.name,
    required this.date,
    required this.amount,
  });

  Income.empty(this.incomeId)
      : userId = '',
        categoryId = '',
        name = '',
        date = DateTime.now(),
        amount = 0;

  IncomeEntity toEntity() {
    return IncomeEntity(
      incomeId: incomeId,
      userId: userId, // Pass userId to IncomeEntity
      categoryId: categoryId,
      name: name,
      date: date,
      amount: amount,
    );
  }

  static Income fromEntity(IncomeEntity entity) {
    return Income(
      incomeId: entity.incomeId,
      userId: entity.userId, // Assign userId from IncomeEntity
      categoryId: entity.categoryId,
      name: entity.name,
      date: entity.date,
      amount: entity.amount,
    );
  }

  @override
  String toString() {
    return 'Income(incomeId: $incomeId, userId: $userId, category: $categoryId, name: $name, date: $date, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Income &&
        other.incomeId == incomeId &&
        other.userId == userId &&
        other.categoryId == categoryId &&
        other.name == name &&
        other.date == date &&
        other.amount == amount;
  }

  @override
  int get hashCode {
    return Object.hash(incomeId, userId, categoryId, name, date, amount);
  }

  Income copyWith({
    String? incomeId,
    String? userId,
    String? categoryId,
    String? name,
    DateTime? date,
    int? amount,
  }) {
    return Income(
      incomeId: incomeId ?? this.incomeId,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      date: date ?? this.date,
      amount: amount ?? this.amount,
    );
  }

}

// import 'package:Income_repository/Income_repository.dart';

// class Income {
//   String incomeId;
//   Category category;
//   DateTime date;
//   int amount;

//   Income({
//     required this.incomeId,
//     required this.category,
//     required this.date,
//     required this.amount,
//   });

//   static final empty = Income(
//     incomeId: '',
//     category: Category.empty,
//     date: DateTime.now(),
//     amount: 0,
//   );

//   IncomeEntity toEntity() {
//     return IncomeEntity(
//       incomeId: incomeId,
//       category: category,
//       date: date,
//       amount: amount,
//     );
//   }

//   static Income fromEntity(IncomeEntity entity) {
//     return Income(
//       incomeId: entity.incomeId,
//       category: entity.category,
//       date: entity.date,
//       amount: entity.amount,
//     );
//   }
// }
