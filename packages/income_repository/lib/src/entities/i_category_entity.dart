class IncCategoryEntity {
  String categoryId;
  String userId; // Add userId field
  String name;
  int totalIncomes;
  String icon;
  int color;

  IncCategoryEntity({
    required this.categoryId,
    required this.userId,
    required this.name,
    required this.totalIncomes,
    required this.icon,
    required this.color,
  });

  Map<String, Object?> toDocument() {
    return {
      'categoryId': categoryId,
      'userId': userId, // Include userId in the document
      'name': name,
      'totalIncomes': totalIncomes,
      'icon': icon,
      'color': color,
    };
  }

  static IncCategoryEntity fromDocument(Map<String, dynamic> doc) {
    return IncCategoryEntity(
      categoryId: doc['categoryId'],
      userId: doc['userId'], // Extract userId from document
      name: doc['name'],
      totalIncomes: doc['totalIncomes'],
      icon: doc['icon'],
      color: doc['color'],
    );
  }
}
