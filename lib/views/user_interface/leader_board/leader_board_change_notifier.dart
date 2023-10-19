import 'package:flutter/material.dart';
import 'package:flutter_bird/views/user_interface/models/rank.dart';


class LeaderBoardChangeNotifier extends ChangeNotifier {

  bool showLeaderBoard = false;
  int rankingSelection = 4;

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

  setRankingSelection(int selection) {
    rankingSelection = selection;
  }

  getRankingSelection() {
    return rankingSelection;
  }

  notify() {
    notifyListeners();
  }
}
