import '../entities/entities.dart';

class ExpCategory {
   final String categoryId;
   final String userId; // Add userId field
   final String name;
   final int totalExpenses;
   final String icon;
   final int color;

  const ExpCategory({
    required this.categoryId,
    required this.userId, // Add userId to the constructor
    required this.name,
    required this.totalExpenses,
    required this.icon,
    required this.color,
  });

  ExpCategory.empty(this.categoryId):
    userId = '',
    name = '',
    totalExpenses = 0,
    icon = '',
    color = 0;

  ExpCategoryEntity toEntity() {
    return ExpCategoryEntity(
      categoryId: categoryId,
      userId: userId, // Pass userId to CategoryEntity
      name: name,
      totalExpenses: totalExpenses,
      icon: icon,
      color: color,
    );
  }

  static ExpCategory fromEntity(ExpCategoryEntity entity) {
    return ExpCategory(
      categoryId: entity.categoryId,
      userId: entity.userId, // Assign userId from CategoryEntity
      name: entity.name,
      totalExpenses: entity.totalExpenses,
      icon: entity.icon,
      color: entity.color,
    );
  }

  ExpCategory copyWith({
    String? categoryId,
    String? userId,
    String? name,
    int? totalExpenses,
    String? icon,
    int? color,
  }) {
    return ExpCategory(
      categoryId: categoryId ?? this.categoryId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      icon: icon ?? this.icon,
      color: color ?? this.color
    );
  }
}
// import '../entities/entities.dart';

// class Category {
//   String categoryId;
//   String name;
//   int totalExpenses;
//   String icon;
//   int color;

//   Category({
//     required this.categoryId,
//     required this.name,
//     required this.totalExpenses,
//     required this.icon,
//     required this.color,
//   });

//   static final empty = Category(
//     categoryId: '',
//     name: '',
//     totalExpenses: 0,
//     icon: '',
//     color: 0,
//   );

//   CategoryEntity toEntity() {
//     return CategoryEntity(
//       categoryId: categoryId,
//       name: name,
//       totalExpenses: totalExpenses,
//       icon: icon,
//       color: color,
//     );
//   }

//   static Category fromEntity(CategoryEntity entity) {
//     return Category(
//       categoryId: entity.categoryId,
//       name: entity.name,
//       totalExpenses: entity.totalExpenses,
//       icon: entity.icon,
//       color: entity.color,
//     );
//   }
// }
