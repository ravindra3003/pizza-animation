import 'package:pizza_animation/screens/diy_pizza_screen.dart';
import 'package:flutter/material.dart';

class IngridientsViewModel extends ChangeNotifier {
  List<Ingridients> ingridients = [];

  addIngridient(Ingridients ingridient) {
    if (ingridients.indexOf(ingridient) == -1) {
      ingridients.add(ingridient);
      notifyListeners();
    }
  }

  removeIngridient(int index) {
    ingridients.removeAt(index);
    notifyListeners();
  }
}
