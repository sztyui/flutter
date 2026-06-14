import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meals/models/favourite_meals.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meal_item.dart';
import 'package:meals/widgets/meal_item_trait.dart';
import 'package:transparent_image/transparent_image.dart';

class MealsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    void moveToMeal(Meal meal) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (ctx) => MealItemScreen(meal: meal)));
    }

    Widget body = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Upss... nothing here!',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            deletable ? 'Try putting something in favourites': 'Try selecting a differend category',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );

    Card cardCreator(meal) {
      return Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8),
        ),
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: InkWell(
          onTap: () => moveToMeal(meal),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FadeInImage(
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(meal.imageUrl),
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 44,
                  ),
                  child: Column(
                    children: [
                      Text(
                        meal.title,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MealItemTrait(
                            icon: Icons.schedule,
                            label: '${meal.duration} min',
                          ),
                          SizedBox(width: 12),
                          MealItemTrait(
                            icon: Icons.work,
                            label: complexityText(meal),
                          ),
                          SizedBox(width: 12),
                          MealItemTrait(
                            icon: Icons.monetization_on,
                            label: affordabilityText(meal),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (meals.isNotEmpty) {
      body = ListView.builder(
        itemCount: meals.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (ctx, index) {
          final meal = meals[index];
          if (deletable) {
            return Dismissible(
              key: Key(meal.id),
              onDismissed: (direction) {
                FavouriteMeals().delete(meal);
              },
              child: cardCreator(meal),
            );
          } else {
            return cardCreator(meal);
          }
        },
      );
    }

    if (title == null) {
      return body;
    }

    return Scaffold(
      appBar: AppBar(title: Text(title!)),
      body: body,
    );
  }
}
