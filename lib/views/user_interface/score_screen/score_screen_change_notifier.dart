import 'package:flutter/material.dart';
import 'package:flutter_bird/views/user_interface/models/achievement.dart';


class ScoreScreenChangeNotifier extends ChangeNotifier {

  bool showScoreScreen = false;

  int currentScore = 0;
  bool isHighScore = false;
  bool twoPlayer = false;

  List<Achievement> achievementGotten = [];

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

  setScore(int score, bool isHighScore) {
    currentScore = score;
    this.isHighScore = isHighScore;
    notifyListeners();
  }

  int getScore() {
    return currentScore;
  }

  bool isTwoPlayer() {
    return twoPlayer;
  }

  setTwoPlayer(bool twoPlayer) {
    this.twoPlayer = twoPlayer;
  }

  notify() {
    notifyListeners();
  }

  clearAchievementList() {
    achievementGotten.clear();
  }

  addAchievement(Achievement achievement) {
    achievementGotten.add(achievement);
  }

  List<Achievement> getAchievementGotten() {
    return achievementGotten;
  }
}
