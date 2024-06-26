class ExpCategoryEntity {
  String categoryId;
  String userId; // Add userId field
  String name;
  int totalExpenses;
  String icon;
  int color;

  ExpCategoryEntity({
    required this.categoryId,
    required this.userId,
    required this.name,
    required this.totalExpenses,
    required this.icon,
    required this.color,
  });

  Map<String, Object?> toDocument() {
    return {
      'categoryId': categoryId,
      'userId': userId, // Include userId in the document
      'name': name,
      'totalExpenses': totalExpenses,
      'icon': icon,
      'color': color,
    };
  }

  static ExpCategoryEntity fromDocument(Map<String, dynamic> doc) {
    return ExpCategoryEntity(
      categoryId: doc['categoryId'],
      userId: doc['userId'], // Extract userId from document
      name: doc['name'],
      totalExpenses: doc['totalExpenses'],
      icon: doc['icon'],
      color: doc['color'],
    );
  }
}

// class CategoryEntity {
//   String categoryId;
//   String name;
//   int totalExpenses;
//   String icon;
//   int color;

//   CategoryEntity({
//     required this.categoryId,
//     required this.name,
//     required this.totalExpenses,
//     required this.icon,
//     required this.color,
//   });

//   Map<String, Object?> toDocument() {
//     return {
//       'categoryId': categoryId,
//       'name': name,
//       'totalExpenses': totalExpenses,
//       'icon': icon,
//       'color': color,
//     };
//   }

//   static CategoryEntity fromDocument(Map<String, dynamic> doc) {
//     return CategoryEntity(
//       categoryId: doc['categoryId'],
//       name: doc['name'],
//       totalExpenses: doc['totalExpenses'],
//       icon: doc['icon'],
//       color: doc['color'],
//     );
//   }
// }
