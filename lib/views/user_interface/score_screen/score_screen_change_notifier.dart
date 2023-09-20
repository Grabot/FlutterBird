import 'package:flutter/material.dart';


class ScoreScreenChangeNotifier extends ChangeNotifier {

  bool showScoreScreen = false;

  static final ScoreScreenChangeNotifier _instance = ScoreScreenChangeNotifier._internal();

  ScoreScreenChangeNotifier._internal();

  factory ScoreScreenChangeNotifier() {
    return _instance;
  }

  setScoreScreenVisible(bool visible) {
    showScoreScreen = visible;
    notifyListeners();
  }

  getScoreScreenVisible() {
    return showScoreScreen;
  }

  notify() {
    notifyListeners();
  }
}
