import 'package:flutter/material.dart';
import 'package:food_recepi/controllers/recpei_controller.dart';
import 'package:food_recepi/views/home_view.dart';
import 'package:food_recepi/widgets/recpeiCard.dart';
import 'package:get/get.dart';

class RecpeiView extends StatelessWidget {
  const RecpeiView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RecipeController controller = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1B1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1B1E),
        elevation: 0,
        title: const Text(
          'Recipes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Get.to(HomeView());
            },
          ),

          const SizedBox(width: 8), // Added padding at the end
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.categories.map((category) {
                        return Column(
                          children: [
                            _buildCategorySection(category, controller),
                            const SizedBox(height: 24),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category, RecipeController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View More',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.getRecipesByCategory(category).length,
              itemBuilder: (context, index) {
                final recipe = controller.getRecipesByCategory(category)[index];
                return RecipeCard(recipe: recipe);
              },
            ),
          ),
        ),
      ],
    );
  }
}
