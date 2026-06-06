import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meal.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, required this.title, required this.meals});

  final String title;
  final List<Meal> meals;

  @override
  Widget build(BuildContext context) {

    void moveToMeal(Meal meal) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => MealPage(meal: meal)
        )
      );
    }

    Widget body = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Uh oh ... nothing here!',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Try selecting a differend category',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
    if (meals.isNotEmpty) {
      body = SizedBox(
        child: ListView.builder(
          itemCount: meals.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: ()=>moveToMeal(meals[index]),
              child: Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: SizedBox(
                    width: 100,
                    child: Image.network(meals[index].imageUrl)
                  ),
                  title: Text(meals[index].title)),
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
    );
  }
}
