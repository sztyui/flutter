import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meal_item.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favourites_provider.dart';

class MealsScreen extends ConsumerWidget {
  const MealsScreen({
    super.key,
    required this.meals,
    required this.deletable,
    this.title,
  });

  final String? title;
  final List<Meal> meals;
  final bool deletable;

  String complexityText(Meal meal) {
    return meal.complexity.name[0].toUpperCase() +
        meal.complexity.name.substring(1);
  }

  String affordabilityText(Meal meal) {
    return meal.affordability.name[0].toUpperCase() +
        meal.affordability.name.substring(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    void moveToMeal(Meal meal) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => MealItemScreen(meal: meal),
        ),
      );
    }

    Widget emptyState = Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                deletable ? Icons.favorite_border : Icons.restaurant_menu,
                size: 64,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              deletable ? 'No Favorites Yet' : 'No Meals Found',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              deletable
                  ? 'Start adding meals to your favorites by tapping the star icon!'
                  : 'Try selecting a different category to discover more meals.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            if (deletable)
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to categories or meals screen
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.explore),
                label: const Text('Explore Meals'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    Widget buildMealCard(Meal meal) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: colorScheme.surface,
            child: InkWell(
              onTap: () => moveToMeal(meal),
              splashColor: colorScheme.primary.withAlpha(10),
              highlightColor: colorScheme.primary.withAlpha(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: FadeInImage(
                          placeholder: MemoryImage(kTransparentImage),
                          image: NetworkImage(meal.imageUrl),
                          fit: BoxFit.cover,
                          height: 180,
                          width: double.infinity,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 180,
                              color: colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.restaurant,
                                size: 48,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            );
                          },
                        ),
                      ),
                      // Duration Badge
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(70),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.schedule,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${meal.duration} min',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Content Section
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildTrait(
                              icon: Icons.fitness_center,
                              label: complexityText(meal),
                              color: _getComplexityColor(meal.complexity.name),
                              theme: theme,
                            ),
                            const SizedBox(width: 8),
                            _buildTrait(
                              icon: Icons.attach_money,
                              label: affordabilityText(meal),
                              color: _getAffordabilityColor(meal.affordability.name),
                              theme: theme,
                            ),
                            const Spacer(),
                            // Favorite indicator
                            Icon(
                              ref.read(favouriteMealsProvider).contains(meal)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: ref.read(favouriteMealsProvider).contains(meal)
                                  ? Colors.red
                                  : colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget body;
    if (meals.isNotEmpty) {
      body = ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: meals.length,
        itemBuilder: (ctx, index) {
          final meal = meals[index];
          if (deletable) {
            return Dismissible(
              key: Key(meal.id),
              direction: DismissDirection.endToStart,
              background: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                final wasAdded = ref
                    .read(favouriteMealsProvider.notifier)
                    .toggleMealFavouriteStatus(meal);
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      wasAdded
                          ? '${meal.title} added to favorites'
                          : '${meal.title} removed from favorites',
                    ),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        ref
                            .read(favouriteMealsProvider.notifier)
                            .toggleMealFavouriteStatus(meal);
                      },
                    ),
                  ),
                );
              },
              child: buildMealCard(meal),
            );
          } else {
            return buildMealCard(meal);
          }
        },
      );
    } else {
      body = emptyState;
    }

    if (title == null) {
      return SafeArea(child: body);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: body
      ),
    );
  }

  Widget _buildTrait({
    required IconData icon,
    required String label,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withAlpha(30),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getComplexityColor(String complexity) {
    switch (complexity.toLowerCase()) {
      case 'simple':
        return Colors.green;
      case 'challenging':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  Color _getAffordabilityColor(String affordability) {
    switch (affordability.toLowerCase()) {
      case 'affordable':
        return Colors.green;
      case 'pricey':
        return Colors.orange;
      case 'luxurious':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
}