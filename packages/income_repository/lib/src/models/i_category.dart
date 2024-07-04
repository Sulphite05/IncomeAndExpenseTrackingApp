import '../entities/entities.dart';

class IncCategory {
  final String categoryId;
  final String userId; // Add userId field
  final String name;
  int totalIncomes;
  final String icon;
  final int color;

  IncCategory({
    required this.categoryId,
    required this.userId, // Add userId to the constructor
    required this.name,
    required this.totalIncomes,
    required this.icon,
    required this.color,
  });

  IncCategory.empty(this.categoryId)
      : userId = '',
        name = '',
        totalIncomes = 0,
        icon = '',
        color = 0;

  IncCategoryEntity toEntity() {
    return IncCategoryEntity(
      categoryId: categoryId,
      userId: userId, // Pass userId to CategoryEntity
      name: name,
      totalIncomes: totalIncomes,
      icon: icon,
      color: color,
    );
  }

  static IncCategory fromEntity(IncCategoryEntity entity) {
    return IncCategory(
      categoryId: entity.categoryId,
      userId: entity.userId, // Assign userId from CategoryEntity
      name: entity.name,
      totalIncomes: entity.totalIncomes,
      icon: entity.icon,
      color: entity.color,
    );
  }

  IncCategory copyWith({
    String? categoryId,
    String? userId,
    String? name,
    int? totalIncomes,
    String? icon,
    int? color,
  }) {
    return IncCategory(
        categoryId: categoryId ?? this.categoryId,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        totalIncomes: totalIncomes ?? this.totalIncomes,
        icon: icon ?? this.icon,
        color: color ?? this.color);
  }

  @override
  String toString() {
    return 'IncCategory(categoryId: $categoryId, userId: $userId, name: $name, totalIncomes: $totalIncomes, icon: $icon, color: $color)';
  }
}
// import '../entities/entities.dart';

// class Category {
//   String categoryId;
//   String name;
//   int totalIncomes;
//   String icon;
//   int color;

//   Category({
//     required this.categoryId,
//     required this.name,
//     required this.totalIncomes,
//     required this.icon,
//     required this.color,
//   });

//   static final empty = Category(
//     categoryId: '',
//     name: '',
//     totalIncomes: 0,
//     icon: '',
//     color: 0,
//   );

//   CategoryEntity toEntity() {
//     return CategoryEntity(
//       categoryId: categoryId,
//       name: name,
//       totalIncomes: totalIncomes,
//       icon: icon,
//       color: color,
//     );
//   }

//   static Category fromEntity(CategoryEntity entity) {
//     return Category(
//       categoryId: entity.categoryId,
//       name: entity.name,
//       totalIncomes: entity.totalIncomes,
//       icon: entity.icon,
//       color: entity.color,
//     );
//   }
// }
