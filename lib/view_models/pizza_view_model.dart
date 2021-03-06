import 'dart:async';
import 'dart:typed_data';

import 'package:pizza_animation/utils/constants.dart';
import 'package:flutter/material.dart';

class PizzaViewModel extends ChangeNotifier {
  double pizzaPrice = 189;
  Map<String, dynamic> selectedPizzaObj = {};
  late AnimationController pizzaAnimationController;
  late Animation<double> pizzaXVal;
  late bool scaleAnimateForward = false;
  late bool scaleAnimateReverse = false;
  late Uint8List pizzaImage;

  SauceType sauceType = SauceType.Plain;

  incPizzaPrice() {
    pizzaPrice++;
    notifyListeners();
  }

  decPizzaPrice() {
    pizzaPrice--;
    notifyListeners();
  }

  setSauceType(SauceType type) {
    sauceType = type;
    notifyListeners();
  }

  getSauceType() {
    if (sauceType == SauceType.Plain)
      return Constants.BREADS[0];
    else if (sauceType == SauceType.PepperyRed)
      return Constants.BREADS[2];
    else if (sauceType == SauceType.TraditionalTomato)
      return Constants.BREADS[1];
    else if (sauceType == SauceType.SpicyRed)
      return Constants.BREADS[3];
    else if (sauceType == SauceType.None) return Constants.BREADS[4];
  }

  animateForward() {
    scaleAnimateForward = true;
    notifyListeners();
    Timer(Duration(milliseconds: 500), () {
      scaleAnimateForward = false;
    });
  }

  animateRev() {
    scaleAnimateReverse = true;
    notifyListeners();
    Timer(Duration(milliseconds: 500), () {
      scaleAnimateReverse = false;
    });
  }
}

enum SauceType {
  Plain,
  PepperyRed,
  TraditionalTomato,
  SpicyRed,
  None,
}
