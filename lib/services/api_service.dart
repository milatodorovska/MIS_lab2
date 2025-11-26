import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/categories.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['categories'] as List)
          .map((e) => Category.fromJson(e))
          .toList();
    }
    throw Exception('Грешка при вчитување категории');
  }

  static Future<List<Meal>> getMealsByCategory(String category) async {
    final response =
    await http.get(Uri.parse('$_baseUrl/filter.php?c=$category'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['meals'] as List?)
          ?.map((e) => Meal.fromJson(e))
          .toList() ??
          [];
    }
    return [];
  }

  static Future<MealDetail?> getMealDetail(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/lookup.php?i=$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null || data['meals'].isEmpty) return null;
      return MealDetail.fromJson(data['meals'][0]);
    }
    return null;
  }

  static Future<MealDetail?> getRandomMeal() async {
    final response = await http.get(Uri.parse('$_baseUrl/random.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MealDetail.fromJson(data['meals'][0]);
    }
    return null;
  }

  static Future<List<Meal>> searchMeals(String query) async {
    final response =
    await http.get(Uri.parse('$_baseUrl/search.php?s=$query'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['meals'] as List?)
          ?.map((e) => Meal.fromJson(e))
          .toList() ??
          [];
    }
    return [];
  }
}