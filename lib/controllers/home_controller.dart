// lib/app/controllers/home_controller.dart

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomeController extends GetxController {
  final GenerativeModel model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: 'AIzaSyBXZLw-FPP5s8fJ83hEjHqKA_qd5gNPXUo',
  );
  
  RxList<Map<String, dynamic>> todayMeals = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> savedRecipes = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxString selectedCategory = 'All'.obs;

  // Predefined categories for recipes
  final categories = [
    'All',
    'Breakfast',
    'Main Course',
    'Dessert',
    'Vegetarian',
    'Quick Meals',
    'Healthy',
  ];

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  // Load saved data from local storage
  void _loadFromStorage() {
    final box = GetStorage();
    final savedMeals = box.read('meals');
    final savedRecs = box.read('recipes');
    
    if (savedMeals != null) {
      todayMeals.value = List<Map<String, dynamic>>.from(savedMeals);
    }
    if (savedRecs != null) {
      savedRecipes.value = List<Map<String, dynamic>>.from(savedRecs);
    }
  }

  // Generate recipe using Gemini AI
  Future<String> generateRecipe(String ingredients) async {
    isLoading.value = true;
    try {
      final prompt = '''Generate a detailed recipe using these ingredients: $ingredients.
                       Please include:
                       1. Recipe name
                       2. Preparation time
                       3. Cooking time
                       4. Detailed steps
                       5. Nutritional information
                       Format it nicely with clear sections.''';
                       
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      isLoading.value = false;
      return response.text ?? 'Failed to generate recipe';
    } catch (e) {
      isLoading.value = false;
      return 'Error generating recipe: $e';
    }
  }

  // Add a new meal to today's meals
  void addMeal(String mealType, String food, int calories) {
    todayMeals.add({
      'type': mealType,
      'food': food,
      'calories': calories,
      'time': DateTime.now().toIso8601String(),
    });
    _updateStorage();
  }

  // Save a generated recipe with categories
  void saveRecipe(String recipe, String ingredients, List<String> categories) {
    savedRecipes.add({
      'recipe': recipe,
      'ingredients': ingredients,
      'categories': categories,
      'timestamp': DateTime.now().toIso8601String(),
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'isFavorite': false,
    });
    _updateStorage();
  }

  // Get recipes filtered by selected category
  List<Map<String, dynamic>> getFilteredRecipes() {
    if (selectedCategory.value == 'All') {
      return savedRecipes;
    }
    return savedRecipes.where((recipe) => 
      (recipe['categories'] as List<String>).contains(selectedCategory.value)
    ).toList();
  }

  // Toggle favorite status of a recipe
  void toggleFavorite(String id) {
    final index = savedRecipes.indexWhere((recipe) => recipe['id'] == id);
    if (index != -1) {
      savedRecipes[index]['isFavorite'] = !(savedRecipes[index]['isFavorite'] as bool);
      _updateStorage();
    }
  }

  // Delete a recipe
  void deleteRecipe(String id) {
    savedRecipes.removeWhere((recipe) => recipe['id'] == id);
    _updateStorage();
  }

  // Clear all meals for today
  void clearTodayMeals() {
    todayMeals.clear();
    _updateStorage();
  }

  // Get total calories for today
  int getTotalCalories() {
    return todayMeals.fold(0, (sum, meal) => sum + (meal['calories'] as int));
  }

  // Update local storage with current data
  void _updateStorage() {
    final box = GetStorage();
    box.write('meals', todayMeals.toList());
    box.write('recipes', savedRecipes.toList());
  }

  // Clean up resources
  @override
  void onClose() {
    super.onClose();
  }
}