import 'package:flutter/material.dart';


class LeaderBoardChangeNotifier extends ChangeNotifier {

  bool showLeaderBoard = false;

  static final LeaderBoardChangeNotifier _instance = LeaderBoardChangeNotifier._internal();

  LeaderBoardChangeNotifier._internal();

  factory LeaderBoardChangeNotifier() {
    return _instance;
  }

  setLeaderBoardVisible(bool visible) {
    showLeaderBoard = visible;
    notifyListeners();
  }

  getLeaderBoardVisible() {
    return showLeaderBoard;
  }

  notify() {
    notifyListeners();
  }
}
