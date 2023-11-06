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
  bool flutterOne = false;
  bool flutterTwo = false;
  bool flutterThree = false;
  bool pipesOne = false;
  bool pipesTwo = false;
  bool pipesThree = false;
  bool perseverance = false;

  int totalNumberOfAchievements = 13;
  int totalAchievementsRetrieved = 0;

  late List<Achievement> allAchievementsAvailable;

  SecureStorage secureStorage = SecureStorage();

  late Achievement bronzeSingleAchievement;
  late Achievement silverSingleAchievement;
  late Achievement goldSingleAchievement;
  late Achievement bronzeDoubleAchievement;
  late Achievement silverDoubleAchievement;
  late Achievement goldDoubleAchievement;
  late Achievement flutterOneAchievement;
  late Achievement flutterTwoAchievement;
  late Achievement flutterThreeAchievement;
  late Achievement pipesOneAchievement;
  late Achievement pipesTwoAchievement;
  late Achievement pipesThreeAchievement;
  late Achievement perseveranceAchievement;

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
    secureStorage.getFlutterOne().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        flutterOne = bool.parse(value);
      }
      createAchievementList();
    });
    secureStorage.getFlutterTwo().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        flutterTwo = bool.parse(value);
      }
      createAchievementList();
    });
    secureStorage.getFlutterThree().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        flutterThree = bool.parse(value);
      }
      createAchievementList();
    });
    secureStorage.getPipesOne().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        pipesOne = bool.parse(value);
      }
      createAchievementList();
    });
    secureStorage.getPipesTwo().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        pipesTwo = bool.parse(value);
      }
      createAchievementList();
    });
    secureStorage.getPipesThree().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        pipesThree = bool.parse(value);
      }
      createAchievementList();
    });
    secureStorage.getPerseverance().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        perseverance = bool.parse(value);
      }
      createAchievementList();
    });
  }

  createAchievementList() {
    if (totalAchievementsRetrieved == totalNumberOfAchievements) {
      bronzeSingleAchievement = Achievement(
          achievementName: "bronzeSingle",
          imageName: "single_bird_bronze_medal",
          tooltip: "got more than 10 points in single player",
          achieved: bronzeSingle
      );
      silverSingleAchievement = Achievement(
          achievementName: "silverSingle",
          imageName: "single_bird_silver_medal",
          tooltip: "got more than 25 points in single player!",
          achieved: silverSingle
      );
      goldSingleAchievement = Achievement(
          achievementName: "goldSingle",
          imageName: "single_bird_gold_medal",
          tooltip: "got more than 100 points in single player!!!",
          achieved: goldSingle
      );
      bronzeDoubleAchievement = Achievement(
          achievementName: "bronzeDouble",
          imageName: "double_bird_bronze_medal",
          tooltip: "got more than 10 points with 2 players",
          achieved: bronzeDouble
      );
      silverDoubleAchievement = Achievement(
          achievementName: "silverDouble",
          imageName: "double_bird_silver_medal",
          tooltip: "got more than 25 points with 2 players!",
          achieved: silverDouble
      );
      goldDoubleAchievement = Achievement(
          achievementName: "goldDouble",
          imageName: "double_bird_gold_medal",
          tooltip: "got more than 100 points with 2 players!!!",
          achieved: goldDouble
      );
      flutterOneAchievement = Achievement(
          achievementName: "flutterOne",
          imageName: "flutter_one",
          tooltip: "You have fluttered your birds already more than a thousand times",
          achieved: flutterOne
      );
      flutterTwoAchievement = Achievement(
          achievementName: "flutterTwo",
          imageName: "flutter_two",
          tooltip: "You have fluttered your birds already more than two thousand and give hundred times!",
          achieved: flutterTwo
      );
      flutterThreeAchievement = Achievement(
          achievementName: "flutterThree",
          imageName: "flutter_three",
          tooltip: "You have fluttered your birds already more than ten thousand times!!!",
          achieved: flutterThree
      );
      pipesOneAchievement = Achievement(
          achievementName: "pipesOne",
          imageName: "pipes_one",
          tooltip: "Your birds have passed a total of two hundred and fifty pipes",
          achieved: pipesOne
      );
      pipesTwoAchievement = Achievement(
          achievementName: "pipesTwo",
          imageName: "pipes_two",
          tooltip: "Your birds have passed a total of one thousand pipes!",
          achieved: pipesTwo
      );
      pipesThreeAchievement = Achievement(
          achievementName: "pipesThree",
          imageName: "pipes_three",
          tooltip: "Your birds have passed a total of five thousand pipes!",
          achieved: pipesThree
      );
      perseveranceAchievement = Achievement(
          achievementName: "perseverance",
          imageName: "bird_placeholder",
          tooltip: "You kept playing the game even after crashing 50 times in a single session!",
          achieved: perseverance
      );
      allAchievementsAvailable = [
        bronzeSingleAchievement,
        silverSingleAchievement,
        goldSingleAchievement,
        bronzeDoubleAchievement,
        silverDoubleAchievement,
        goldDoubleAchievement,
        flutterOneAchievement,
        flutterTwoAchievement,
        flutterThreeAchievement,
        pipesOneAchievement,
        pipesTwoAchievement,
        pipesThreeAchievement,
        perseveranceAchievement
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
    flutterOne = false;
    flutterTwo = false;
    flutterThree = false;
    pipesOne = false;
    pipesTwo = false;
    pipesThree = false;
    perseverance = false;
    secureStorage.setBronzeSingle("false");
    secureStorage.setSilverSingle("false");
    secureStorage.setGoldSingle("false");
    secureStorage.setBronzeDouble("false");
    secureStorage.setSilverDouble("false");
    secureStorage.setGoldDouble("false");
    secureStorage.setFlutterOne("false");
    secureStorage.setFlutterTwo("false");
    secureStorage.setFlutterThree("false");
    secureStorage.setPipesOne("false");
    secureStorage.setPipesTwo("false");
    secureStorage.setPipesThree("false");
    secureStorage.setPerseverance("false");
    bronzeSingleAchievement.achieved = false;
    silverSingleAchievement.achieved = false;
    goldSingleAchievement.achieved = false;
    bronzeDoubleAchievement.achieved = false;
    silverDoubleAchievement.achieved = false;
    goldDoubleAchievement.achieved = false;
    flutterOneAchievement.achieved = false;
    flutterTwoAchievement.achieved = false;
    flutterThreeAchievement.achieved = false;
    pipesOneAchievement.achieved = false;
    pipesTwoAchievement.achieved = false;
    pipesThreeAchievement.achieved = false;
    perseveranceAchievement.achieved = false;
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

  getFlutterOne() {
    return flutterOne;
  }
  achievedFlutterOne() async {
    flutterOne = true;
    flutterOneAchievement.achieved = true;
    secureStorage.setFlutterOne(flutterOne.toString());
  }

  getFlutterTwo() {
    return flutterTwo;
  }
  achievedFlutterTwo() async {
    flutterTwo = true;
    flutterTwoAchievement.achieved = true;
    secureStorage.setFlutterTwo(flutterTwo.toString());
  }

  getFlutterThree() {
    return flutterThree;
  }
  achievedFlutterThree() async {
    flutterThree = true;
    flutterThreeAchievement.achieved = true;
    secureStorage.setFlutterThree(flutterThree.toString());
  }

  getPipesOne() {
    return pipesOne;
  }
  achievedPipesOne() async {
    pipesOne = true;
    pipesOneAchievement.achieved = true;
    secureStorage.setPipesOne(pipesOne.toString());
  }

  getPipesTwo() {
    return pipesTwo;
  }
  achievedPipesTwo() async {
    pipesTwo = true;
    pipesTwoAchievement.achieved = true;
    secureStorage.setPipesTwo(pipesTwo.toString());
  }

  getPipesThree() {
    return pipesThree;
  }
  achievedPipesThree() async {
    pipesThree = true;
    pipesThreeAchievement.achieved = true;
    secureStorage.setPipesThree(pipesThree.toString());
  }

  getPerseverance() {
    return perseverance;
  }
  achievedPerseverance() async {
    perseverance = true;
    perseveranceAchievement.achieved = true;
    secureStorage.setPerseverance(perseverance.toString());
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
        goldDouble,
        flutterOne,
        flutterTwo,
        flutterThree,
        pipesOne,
        pipesTwo,
        pipesThree,
        perseverance
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
  bool flutterOne = false;
  bool flutterTwo = false;
  bool flutterThree = false;
  bool pipesOne = false;
  bool pipesTwo = false;
  bool pipesThree = false;
  bool perseverance = false;

  Achievements(this.bronzeSingle, this.silverSingle, this.goldSingle, this.bronzeDouble, this.silverDouble, this.goldDouble, this.flutterOne, this.flutterTwo, this.flutterThree, this.pipesOne, this.pipesTwo, this.pipesThree, this.perseverance);

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
    if (json.containsKey("flutter_one")) {
      flutterOne = json["flutter_one"];
    }
    if (json.containsKey("flutter_two")) {
      flutterTwo = json["flutter_two"];
    }
    if (json.containsKey("flutter_three")) {
      flutterThree = json["flutter_three"];
    }
    if (json.containsKey("pipes_one")) {
      pipesOne = json["pipes_one"];
    }
    if (json.containsKey("pipes_two")) {
      pipesTwo = json["pipes_two"];
    }
    if (json.containsKey("pipes_three")) {
      pipesThree = json["pipes_three"];
    }
    if (json.containsKey("perseverance")) {
      perseverance = json["perseverance"];
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
    if (flutterOne) {
      json['flutter_one'] = flutterOne;
    }
    if (flutterTwo) {
      json['flutter_two'] = flutterTwo;
    }
    if (flutterThree) {
      json['flutter_three'] = flutterThree;
    }
    if (pipesOne) {
      json['pipes_one'] = pipesOne;
    }
    if (pipesTwo) {
      json['pipes_two'] = pipesTwo;
    }
    if (pipesThree) {
      json['pipes_three'] = pipesThree;
    }
    if (perseverance) {
      json['perseverance'] = perseverance;
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

  bool getFlutterOne() {
    return flutterOne;
  }
  setFlutterOne(bool flutterOne) {
    this.flutterOne = flutterOne;
  }

  bool getFlutterTwo() {
    return flutterTwo;
  }
  setFlutterTwo(bool flutterTwo) {
    this.flutterTwo = flutterTwo;
  }

  bool getFlutterThree() {
    return flutterThree;
  }
  setFlutterThree(bool flutterThree) {
    this.flutterThree = flutterThree;
  }

  bool getPipesOne() {
    return pipesOne;
  }
  setPipesOne(bool pipesOne) {
    this.pipesOne = pipesOne;
  }

  bool getPipesTwo() {
    return pipesTwo;
  }
  setPipesTwo(bool pipesTwo) {
    this.pipesTwo = pipesTwo;
  }

  bool getPipesThree() {
    return pipesThree;
  }
  setPipesThree(bool pipesThree) {
    this.pipesThree = pipesThree;
  }

  bool getPerseverance() {
    return perseverance;
  }
  setPerseverance(bool perseverance) {
    this.perseverance = perseverance;
  }
}
