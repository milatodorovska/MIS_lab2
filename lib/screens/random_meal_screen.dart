import 'package:flutter/material.dart';
import '../models/meal_detail.dart';
import 'meal_detail_screen.dart';

class RandomMealScreen extends StatelessWidget {
  final MealDetail meal;

  const RandomMealScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Рандом рецепт на денот')),
      body: MealDetailScreen(mealId: meal.id), // повторно ги користи истиот widget
    );
  }
}