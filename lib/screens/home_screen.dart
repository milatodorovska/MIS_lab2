import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/category.dart';
import '../widgets/category_card.dart';
import 'random_meal_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Category>> futureCategories;
  List<Category> allCategories = [];
  List<Category> filteredCategories = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureCategories = ApiService.getCategories();
    futureCategories.then((categories) {
      setState(() {
        allCategories = categories;
        filteredCategories = categories;
      });
    });
  }

  void _filterCategories(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCategories = allCategories;
      });
    } else {
      setState(() {
        filteredCategories = allCategories
            .where((cat) =>
        cat.name.toLowerCase().contains(query.toLowerCase()) ||
            cat.description.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории на рецепти'),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.casino),
            tooltip: 'Рандом рецепт на денот',
            onPressed: () async {
              final meal = await ApiService.getRandomMeal();
              if (!mounted || meal == null) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RandomMealScreen(meal: meal),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Пребарување
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Пребарај категории... (на пр. Beef, Dessert)',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: _filterCategories,
            ),
          ),

          // Листа на категории
          Expanded(
            child: FutureBuilder<List<Category>>(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (filteredCategories.isEmpty && _searchController.text.isNotEmpty) {
                    return const Center(
                      child: Text('Нема пронајдено категории'),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.88,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: filteredCategories.length,
                    itemBuilder: (ctx, i) => CategoryCard(
                      category: filteredCategories[i],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Грешка: ${snapshot.error}'));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}