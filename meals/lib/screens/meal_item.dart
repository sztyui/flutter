import 'package:flutter/material.dart';
import 'package:meals/models/favourite_meals.dart';
import 'package:meals/models/meal.dart';


class MealItemScreen extends StatelessWidget {
  const MealItemScreen({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final ingridients = meal.ingredients.map((str) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u2022',
            style: TextStyle(
              fontSize: 16,
              height: 1.55,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            str,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      );
    }).toList();

    final steps = meal.steps
        .asMap()
        .map((i, element) {
          return MapEntry(
            i,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${i + 1}: ',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    element,
                    softWrap: true,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          );
        })
        .values
        .toList();

    Row getAffordabilty() {
      if (meal.affordability == Affordability.affordable) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on, color: Colors.white,),
          ],
        );
      } else if (meal.affordability == Affordability.pricey) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on, color: Colors.white,),
            SizedBox(width: 2),
            Icon(Icons.monetization_on, color: Colors.white,),
          ],
        );
      }
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.monetization_on, color: Colors.white,),
            SizedBox(width: 2),
            Icon(Icons.monetization_on, color: Colors.white,),
            SizedBox(width: 2),
            Icon(Icons.monetization_on, color: Colors.white,),
          ],
        );
    }

    String isGlutenFree() {
      if (meal.isGlutenFree) {
        return "✅🍞";
      }
      return "🚫🍞";
    }

    String isVegetarian() {
      if (meal.isVegetarian) {
        return "✅🐄";
      }
      return "🚫🐄";
    }

    String isVegan() {
      if (meal.isVegan) {
        return "✅🍅";
      }
      return "🚫🍅";
    }

    String isLactoseFree() {
      return !meal.isLactoseFree ? "✅🥛" : "🚫🥛";
    }

    String getComplexity() {
      if (meal.complexity == Complexity.simple) {
        return '💪🏻 (${meal.complexity.name})';
      } else if (meal.complexity == Complexity.challenging) {
        return '💪🏻💪🏻 (${meal.complexity.name})';
      }
      return '💪🏻💪🏻😓 (${meal.complexity.name})';
    }

    final br = BorderRadius.only(
      topLeft: Radius.circular(8),
      topRight: Radius.circular(16),
      bottomLeft: Radius.circular(4),
      bottomRight: Radius.circular(12),
    );

    Color favIconColor = Colors.white;
    if(FavouriteMeals().exists(meal)) {
      favIconColor = Colors.amberAccent;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(onPressed: () {
            if(!FavouriteMeals().exists(meal)){
              FavouriteMeals().add(meal);
            } else {
              FavouriteMeals().delete(meal);
            }
            
          }, icon: Icon(Icons.star, color: favIconColor,))
        ]
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: br,
              child: Image.network(meal.imageUrl, height: 150, width: 250, fit: BoxFit.cover,)
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Text(
                    'Affordability: ',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  getAffordabilty(),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  Text(
                    'Complexity:',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    getComplexity(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Gluten: ${isGlutenFree()}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    'Vegan: ${isVegan()}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Vegetarian: ${isVegetarian()}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Text(
                    'Lactose:: ${isLactoseFree()}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Ingredients:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: ingridients,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Steps for cooking:',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsetsGeometry.fromSTEB(16, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: steps,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
