import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/util/web_storage.dart';
import 'package:flutter_bird/views/user_interface/models/achievement.dart';
import 'package:isolated_worker/js_isolated_worker.dart';


class UserAchievements {
  static final UserAchievements _instance = UserAchievements._internal();

  bool bronzeSingle = false;
  bool silverSingle = false;
  bool goldSingle = false;
  bool bronzeDouble = false;
  bool silverDouble = false;
  bool goldDouble = false;

  int totalNumberOfAchievements = 6;
  int totalAchievementsRetrieved = 0;

  late List<Achievement> allAchievementsAvailable;

  SecureStorage secureStorage = SecureStorage();

  late Achievement bronzeSingleAchievement;
  late Achievement silverSingleAchievement;
  late Achievement goldSingleAchievement;
  late Achievement bronzeDoubleAchievement;
  late Achievement silverDoubleAchievement;
  late Achievement goldDoubleAchievement;

  UserAchievements._internal() {
    // retrieve storage
    secureStorage.getBronzeSingle().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        bronzeSingle = bool.parse(value);
      }
      createAchievementList();
    });
    secureStorage.getSilverSingle().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        silverSingle = bool.parse(value);
      }
      createAchievementList();
    });
    secureStorage.getGoldSingle().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        goldSingle = bool.parse(value);
      }
      createAchievementList();
    });
    secureStorage.getBronzeDouble().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        bronzeDouble = bool.parse(value);
      }
      createAchievementList();
    });
    secureStorage.getSilverDouble().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        silverDouble = bool.parse(value);
      }
      createAchievementList();
    });
    secureStorage.getGoldDouble().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        goldDouble = bool.parse(value);
      }
      createAchievementList();
    });
  }

  createAchievementList() {
    if (totalAchievementsRetrieved == totalNumberOfAchievements) {
      bronzeSingleAchievement = Achievement(
          imageName: "bird_1",
          tooltip: "got more than 10 points in single player",
          achieved: bronzeSingle
      );
      silverSingleAchievement = Achievement(
          imageName: "bird_1",
          tooltip: "got more than 25 points in single player!",
          achieved: silverSingle
      );
      goldSingleAchievement = Achievement(
          imageName: "bird_1",
          tooltip: "got more than 100 points in single player!!!",
          achieved: goldSingle
      );
      bronzeDoubleAchievement = Achievement(
          imageName: "bird_1",
          tooltip: "got more than 10 points with 2 players",
          achieved: bronzeDouble
      );
      silverDoubleAchievement = Achievement(
          imageName: "bird_1",
          tooltip: "got more than 25 points with 2 players!",
          achieved: silverDouble
      );
      goldDoubleAchievement = Achievement(
          imageName: "bird_1",
          tooltip: "got more than 100 points with 2 players!!!",
          achieved: goldDouble
      );
      allAchievementsAvailable = [
        bronzeSingleAchievement,
        silverSingleAchievement,
        goldSingleAchievement,
        bronzeDoubleAchievement,
        silverDoubleAchievement,
        goldDoubleAchievement
      ];
    }
  }

  factory UserAchievements() {
    return _instance;
  }

  logout() {
    bronzeSingle = false;
    silverSingle = false;
    goldSingle = false;
    bronzeDouble = false;
    silverDouble = false;
    goldDouble = false;
    secureStorage.setBronzeSingle("false");
    secureStorage.setSilverSingle("false");
    secureStorage.setGoldSingle("false");
    secureStorage.setBronzeDouble("false");
    secureStorage.setSilverDouble("false");
    secureStorage.setGoldDouble("false");
    bronzeSingleAchievement.achieved = false;
    silverSingleAchievement.achieved = false;
    goldSingleAchievement.achieved = false;
    bronzeDoubleAchievement.achieved = false;
    silverDoubleAchievement.achieved = false;
    goldDoubleAchievement.achieved = false;
  }

  getBronzeSingle() {
    return bronzeSingle;
  }
  achievedBronzeSingle() async {
    this.bronzeSingle = true;
    bronzeSingleAchievement.achieved = true;
    secureStorage.setBronzeSingle(bronzeSingle.toString());
  }

  getSilverSingle() {
    return silverSingle;
  }
  achievedSilverSingle() async {
    silverSingle = true;
    silverSingleAchievement.achieved = true;
    secureStorage.setSilverSingle(silverSingle.toString());
  }

  getGoldSingle() {
    return goldSingle;
  }
  achievedGoldSingle() async {
    goldSingle = true;
    goldSingleAchievement.achieved = true;
    secureStorage.setGoldSingle(goldSingle.toString());
  }

  getBronzeDouble() {
    return bronzeDouble;
  }
  achievedBronzeDouble() async {
    bronzeDouble = true;
    bronzeDoubleAchievement.achieved = true;
    secureStorage.setBronzeDouble(bronzeDouble.toString());
  }

  getSilverDouble() {
    return silverDouble;
  }
  achievedSilverDouble() async {
    silverDouble = true;
    silverDoubleAchievement.achieved = true;
    secureStorage.setSilverDouble(silverDouble.toString());
  }

  getGoldDouble() {
    return goldDouble;
  }
  achievedGoldDouble() async {
    goldDouble = true;
    goldDoubleAchievement.achieved = true;
    secureStorage.setGoldDouble(goldDouble.toString());
  }

  List<Achievement> getAchievementsAvailable() {
    return allAchievementsAvailable;
  }

  List<Achievement> achievedAchievementList() {
    List<Achievement> achievedAchievements = [];
    for (Achievement achievement in allAchievementsAvailable) {
      if (achievement.achieved) {
        achievedAchievements.add(achievement);
      }
    }
    return achievedAchievements;
  }

  Achievements getAchievements() {
    return Achievements(
        bronzeSingle,
        silverSingle,
        goldSingle,
        bronzeDouble,
        silverDouble,
        goldDouble
    );
  }
}

class Achievements {

  bool bronzeSingle = false;
  bool silverSingle = false;
  bool goldSingle = false;
  bool bronzeDouble = false;
  bool silverDouble = false;
  bool goldDouble = false;

  Achievements(this.bronzeSingle, this.silverSingle, this.goldSingle, this.bronzeDouble, this.silverDouble, this.goldDouble);

  Achievements.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("bronze_single")) {
      bronzeSingle = json["bronze_single"];
    }
    if (json.containsKey("silver_single")) {
      silverSingle = json["silver_single"];
    }
    if (json.containsKey("gold_single")) {
      goldSingle = json["gold_single"];
    }
    if (json.containsKey("bronze_double")) {
      bronzeDouble = json["bronze_double"];
    }
    if (json.containsKey("silver_double")) {
      silverDouble = json["silver_double"];
    }
    if (json.containsKey("gold_double")) {
      goldDouble = json["gold_double"];
    }
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};

    if (bronzeSingle) {
      json['bronze_single'] = bronzeSingle;
    }
    if (silverSingle) {
      json['silver_single'] = silverSingle;
    }
    if (goldSingle) {
      json['gold_single'] = goldSingle;
    }
    if (bronzeDouble) {
      json['bronze_double'] = bronzeDouble;
    }
    if (silverDouble) {
      json['silver_double'] = silverDouble;
    }
    if (goldDouble) {
      json['gold_double'] = goldDouble;
    }
    return json;
  }

  bool getBronzeSingle() {
    return bronzeSingle;
  }
  setBronzeSingle(bool bronzeSingle) {
    this.bronzeSingle = bronzeSingle;
  }

  bool getSilverSingle() {
    return silverSingle;
  }
  setSilverSingle(bool silverSingle) {
    this.silverSingle = silverSingle;
  }

  bool getGoldSingle() {
    return goldSingle;
  }
  setGoldSingle(bool goldSingle) {
    this.goldSingle = goldSingle;
  }

  bool getBronzeDouble() {
    return bronzeDouble;
  }
  setBronzeDouble(bool bronzeDouble) {
    this.bronzeDouble = bronzeDouble;
  }

  bool getSilverDouble() {
    return silverDouble;
  }
  setSilverDouble(bool silverDouble) {
    this.silverDouble = silverDouble;
  }

  bool getGoldDouble() {
    return goldDouble;
  }
  setGoldDouble(bool goldDouble) {
    this.goldDouble = goldDouble;
  }
}
