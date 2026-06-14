import 'package:meals/models/meal.dart';

enum NotificationType {
  add,
  delete,
}

class NotificationCallback {
  NotificationCallback({required this.fn, required this.type});

  void Function(NotificationType, Meal) fn;
  NotificationType type;
}

class FavouriteMeals {
  static final FavouriteMeals _favouritemeals = FavouriteMeals._internal();

  List<Meal> meals = [];
  List<NotificationCallback> notificated = []; 

  factory FavouriteMeals() {
    return _favouritemeals;
  }

  FavouriteMeals._internal();

  void notify(NotificationType type, Meal meal) {
    notificated
        .where((n) => n.type == type)
        .forEach((n) { 
          n.fn(type, meal); 
          removeNotification(type, n.fn); 
        });
  }

  void delete(Meal meal) {
    if(meals.contains(meal)){
      meals.remove(meal);
      notify(NotificationType.delete, meal);
    }
  }

  bool exists(Meal meal) {
    return meals.contains(meal);
  }

  void add(Meal meal) {
    if(!meals.contains(meal)){
      meals.add(meal);
      notify(NotificationType.add, meal);
    }
  }

  List<Meal> get getMeals {
    return meals;
  }

  void setNotificated(NotificationType notificationType, void Function(NotificationType, Meal) functionCallback) {
    final nc = NotificationCallback(fn: functionCallback, type: notificationType);
    if(!notificated.contains(nc)){
      notificated.add(nc);
    } 
  }

  void removeNotification(
    NotificationType type,
    void Function(NotificationType, Meal) callback,
  ) {
    notificated.removeWhere(
      (n) => n.type == type && n.fn == callback,
    );
  }
}