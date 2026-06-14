import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favourites_provider.dart';

class MealItemScreen extends ConsumerWidget {
  const MealItemScreen({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Watch the favorites provider to react to changes
    final favoriteMeals = ref.watch(favouriteMealsProvider);
    final isFavorite = favoriteMeals.contains(meal);
    
    final ingredients = meal.ingredients.map((str) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6, right: 12),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            Expanded(
              child: Text(
                str,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();

    final steps = meal.steps.asMap().entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${entry.key + 1}',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  entry.value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
            onPressed: () {
              // Toggle favorite status
              ref.read(favouriteMealsProvider.notifier).toggleMealFavouriteStatus(meal);
            },
            icon: Icon(
              isFavorite ? Icons.favorite_outlined : Icons.favorite_outline,
              color: isFavorite ? Colors.red : colorScheme.onSurface,
            ),
            tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section
            _buildHeroImage(context),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Info Cards
                  _buildQuickInfoCards(context),
                  
                  const SizedBox(height: 24),
                  
                  // Dietary Info
                  _buildSectionTitle(context, 'Dietary Information'),
                  const SizedBox(height: 12),
                  _buildDietaryTags(context),
                  
                  const SizedBox(height: 24),
                  
                  // Ingredients
                  _buildSectionTitle(context, 'Ingredients'),
                  const SizedBox(height: 12),
                  _buildIngredientsCard(context, ingredients),
                  
                  const SizedBox(height: 24),
                  
                  // Steps
                  _buildSectionTitle(context, 'Cooking Steps'),
                  const SizedBox(height: 12),
                  ...steps,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: Image.network(
              meal.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.restaurant,
                    size: 64,
                    color: colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.fitness_center,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  meal.complexity.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickInfoCards(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context,
            icon: Icons.attach_money,
            label: 'Affordability',
            value: meal.affordability.name[0].toUpperCase() + 
                   meal.affordability.name.substring(1),
            color: _getAffordabilityColor(colorScheme),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            context,
            icon: Icons.timer_outlined,
            label: 'Duration',
            value: '${meal.duration} min',
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getAffordabilityColor(ColorScheme colorScheme) {
    switch (meal.affordability) {
      case Affordability.affordable:
        return Colors.green;
      case Affordability.pricey:
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Text(
      title,
      style: TextStyle(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  Widget _buildDietaryTags(BuildContext context) {
    final tags = [
      _DietaryTag(
        label: 'Gluten Free',
        isCompliant: meal.isGlutenFree,
        icon: Icons.grain,
      ),
      _DietaryTag(
        label: 'Vegetarian',
        isCompliant: meal.isVegetarian,
        icon: Icons.eco,
      ),
      _DietaryTag(
        label: 'Vegan',
        isCompliant: meal.isVegan,
        icon: Icons.spa,
      ),
      _DietaryTag(
        label: 'Lactose Free',
        isCompliant: meal.isLactoseFree,
        icon: Icons.water_drop,
      ),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: tag.isCompliant
                ? Colors.green.withAlpha(10)
                : Colors.red.withAlpha(10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: tag.isCompliant
                  ? Colors.green.withAlpha(30)
                  : Colors.red.withAlpha(30),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                tag.isCompliant ? Icons.check_circle : Icons.cancel,
                size: 16,
                color: tag.isCompliant ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 6),
              Text(
                tag.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: tag.isCompliant ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIngredientsCard(BuildContext context, List<Widget> ingredients) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: ingredients,
      ),
    );
  }
}

class _DietaryTag {
  final String label;
  final bool isCompliant;
  final IconData icon;

  _DietaryTag({
    required this.label,
    required this.isCompliant,
    required this.icon,
  });
}