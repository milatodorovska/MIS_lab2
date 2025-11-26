class Category {
  final String name;
  final String thumbnail;
  final String description;

  Category({required this.name, required this.thumbnail, required this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['strCategory'],
      thumbnail: json['strCategoryThumb'],
      description: json['strCategoryDescription'],
    );
  }
}