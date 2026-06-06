import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';

class MealPage extends StatelessWidget {
  const MealPage({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final ingridients = meal.ingredients.map((str) {
      return Row(
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
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
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
                  '${i+1}: ',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.55,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  element,
                  softWrap: true,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        })
        .values
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text(meal.title)),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.network(meal.imageUrl, height: 200, width: 250),
                const SizedBox(width: 24),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  'Ingredients:',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
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
            Row(
              children: [
                Text(
                  'Steps for cooking:',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
          ],
        ),
      ),
    );
  }
}
