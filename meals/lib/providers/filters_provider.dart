import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:meals/providers/meals_provider.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

typedef FilterMap = Map<Filter, bool>;

class FiltersNotifier extends StateNotifier<FilterMap> {
  FiltersNotifier()
    : super({
        Filter.glutenFree: false,
        Filter.lactoseFree: false,
        Filter.vegan: false,
        Filter.vegetarian: false,
      });

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }

  void setFilters(FilterMap choosenFilters) {
    state = choosenFilters;
  }
}

final filtersProvider = StateNotifierProvider<FiltersNotifier, FilterMap>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }

    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }

    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }

    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();

});
