import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/util/web_storage.dart';
import 'package:isolated_worker/js_isolated_worker.dart';


class UserScore {
  static final UserScore _instance = UserScore._internal();

  int bestScore = 0;
  int totalFlutters = 0;
  int totalPipesCleared = 0;
  int totalGames = 0;

  SecureStorage secureStorage = SecureStorage();

  UserScore._internal() {
    // retrieve storage
    secureStorage.getTotalFlutters().then((value) {
      if (value != null) {
        totalFlutters = int.parse(value);
      }
    });
    secureStorage.getTotalPipes().then((value) {
      if (value != null) {
        totalPipesCleared = int.parse(value);
      }
    });
    secureStorage.getTotalGames().then((value) {
      if (value != null) {
        totalGames = int.parse(value);
      }
    });
    secureStorage.getBestScore().then((value) {
      if (value != null) {
        bestScore = int.parse(value);
      }
    });
  }

  updateStoreStorage() {
    secureStorage.setTotalFlutters(totalFlutters.toString());
    secureStorage.setTotalPipes(totalPipesCleared.toString());
    secureStorage.setTotalGames(totalGames.toString());
    secureStorage.setBestScore(bestScore.toString());
  }

  factory UserScore() {
    return _instance;
  }

  int getBestScore() {
    return bestScore;
  }

  setBestScore(int bestScore) async {
    this.bestScore = bestScore;
    await secureStorage.setBestScore(bestScore.toString());
  }

  addTotalFlutters(int flutters) async {
    totalFlutters += flutters;
    await secureStorage.setTotalFlutters(totalFlutters.toString());
  }

  setTotalFlutters(int flutters) async {
    totalFlutters = flutters;
    await secureStorage.setTotalFlutters(totalFlutters.toString());
  }

  getTotalFlutters() {
    return totalFlutters;
  }

  addTotalPipesCleared(int pipesCleared) async {
    totalPipesCleared += pipesCleared;
    await secureStorage.setTotalPipes(totalPipesCleared.toString());
  }

  setTotalPipesCleared(int pipesCleared) async {
    totalPipesCleared = pipesCleared;
    await secureStorage.setTotalPipes(totalPipesCleared.toString());
  }

  getTotalPipesCleared() {
    return totalPipesCleared;
  }

  addTotalGames(int games) async {
    totalGames += games;
    await secureStorage.setTotalGames(totalGames.toString());
  }

  getTotalGames() {
    return totalGames;
  }

  setTotalGames(int games) async {
    totalGames = games;
    await secureStorage.setTotalGames(totalGames.toString());
  }

  getScore() {
    return Score(
      bestScore,
      totalFlutters,
      totalPipesCleared,
      totalGames,
    );
  }

  logout() async {
    bestScore = 0;
    totalFlutters = 0;
    totalPipesCleared = 0;
    totalGames = 0;
    await secureStorage.setTotalGames("0");
    await secureStorage.setTotalPipes("0");
    await secureStorage.setTotalFlutters("0");
    await secureStorage.setBestScore("0");
  }
}

class Score {

  int bestScore = 0;
  int totalFlutters = 0;
  int totalPipesCleared = 0;
  int totalGames = 0;

  Score(this.bestScore, this.totalFlutters, this.totalPipesCleared, this.totalGames);

  Score.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("best_score")) {
      bestScore = json["best_score"];
    }
    if (json.containsKey("total_flutters")) {
      totalFlutters = json["total_flutters"];
    }
    if (json.containsKey("total_pipes_cleared")) {
      totalPipesCleared = json["total_pipes_cleared"];
    }
    if (json.containsKey("total_games")) {
      totalGames = json["total_games"];
    }
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};

    json['best_score'] = bestScore;
    json['total_flutters'] = totalFlutters;
    json['total_pipes_cleared'] = totalPipesCleared;
    json['total_games'] = totalGames;
    return json;
  }

  int getBestScore() {
    return bestScore;
  }
  int getTotalFlutters() {
    return totalFlutters;
  }
  int getTotalPipesCleared() {
    return totalPipesCleared;
  }
  int getTotalGames() {
    return totalGames;
  }
  setTotalGames(int games) {
    totalGames = games;
  }
  setTotalPipesCleared(int pipesCleared) {
    totalPipesCleared = pipesCleared;
  }
  setTotalFlutters(int flutters) {
    totalFlutters = flutters;
  }
  setBestScore(int score) {
    bestScore = score;
  }
}
