import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/favourite_meals.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

const kInitialFilters = {
    Filter.glutenFree: false,
    Filter.lactoseFree: false,
    Filter.vegetarian: false,
    Filter.vegan: false,
  };

bool mealFilterer(Meal meal, Map<Filter, bool> filter){

  if(filter[Filter.glutenFree]! && !meal.isGlutenFree) {
    return false;
  }

  if(filter[Filter.lactoseFree]! && !meal.isLactoseFree) {
    return false;
  }

  if(filter[Filter.vegetarian]! && !meal.isVegetarian) {
    return false;
  }

  if(filter[Filter.vegan]! && !meal.isVegan) {
    return false;
  }
  return true;
}

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabScreen> {
  int _selectedPageIndex = 0;
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  final ValueNotifier<int> favouriteCount = ValueNotifier(0);

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setNumberOfFavourites(NotificationType type, Meal meal) {
    log('have: ${favouriteCount.value}, got: $num');
    if(type == NotificationType.add) {
      _showInfoMessage('${meal.title} added for favourites.');
      setState(() {
        favouriteCount.value += 1;
      });
    } else {
      _showInfoMessage('${meal.title} deleted from favourites.');
      setState(() {
        favouriteCount.value -= 1;
      });
    }
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if(identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(MaterialPageRoute(builder: (ctx)=> FiltersScreen(currentFilters: _selectedFilters)));
      setState(() {
        _selectedFilters = result ?? kInitialFilters;  
      });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    FavouriteMeals().setNotificated(NotificationType.add, _setNumberOfFavourites);
    FavouriteMeals().setNotificated(NotificationType.delete, _setNumberOfFavourites);

    final availableMeals = dummyMeals.where((meal) => mealFilterer(meal, _selectedFilters)).toList();


    Widget activePage = CategoriesScreen(availableMeals: availableMeals,);
    var activePageTitle = 'Categories';
    if(_selectedPageIndex == 1) {
      activePage = MealsScreen(meals: FavouriteMeals().getMeals, deletable: true,);
      activePageTitle = 'Your Favourites';
    }

    var navBar = ValueListenableBuilder(
      valueListenable: favouriteCount,
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(title: Text(activePageTitle)),
          drawer: MainDrawer(onSelectScreen: _setScreen,),
          body: activePage,
          bottomNavigationBar: BottomNavigationBar(
            onTap: _selectPage,
            currentIndex: _selectedPageIndex,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.set_meal),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.star, color: favouriteCount.value > 0 ? Colors.amber : Colors.white,),
                label: 'Favourites (${favouriteCount.value})',
              ),
            ],
          ),
        );
      },
    );

    return navBar;
  }
}