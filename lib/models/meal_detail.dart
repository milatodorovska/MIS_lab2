class MealDetail {
  final String id;
  final String name;
  final String thumbnail;
  final String instructions;
  final String? youtube;
  final List<String> ingredients;

  MealDetail({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.instructions,
    this.youtube,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      String ingredient = (json['strIngredient$i'] ?? '').trim();
      String measure = (json['strMeasure$i'] ?? '').trim();
      if (ingredient.isNotEmpty) {
        ingredients.add('$measure $ingredient'.trim());
      }
    }

    return MealDetail(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
      youtube: json['strYoutube'],
      ingredients: ingredients,
    );
  }
}