import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/util/web_storage.dart';
import 'package:flutter_bird/views/user_interface/models/achievement.dart';
import 'package:flutter_bird/views/user_interface/score_screen/score_screen_change_notifier.dart';
import 'package:isolated_worker/js_isolated_worker.dart';


class UserAchievements {
  static final UserAchievements _instance = UserAchievements._internal();

  bool woodSingle = false;
  bool bronzeSingle = false;
  bool silverSingle = false;
  bool goldSingle = false;
  bool woodDouble = false;
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
  bool nightOwl = false;
  bool wingedWarrior = false;
  bool platforms = false;
  // You achieve it when you log in, you later show the achievement
  // We use this variable to check if we just achieved it.
  bool justAchievedPlatforms = false;

  int totalNumberOfAchievements = 15;
  int totalAchievementsRetrieved = 0;

  late List<Achievement> allAchievementsAvailable;

  SecureStorage secureStorage = SecureStorage();

  late Achievement woodSingleAchievement;
  late Achievement bronzeSingleAchievement;
  late Achievement silverSingleAchievement;
  late Achievement goldSingleAchievement;
  late Achievement woodDoubleAchievement;
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
  late Achievement nightOwlAchievement;
  late Achievement wingedWarriorAchievement;
  late Achievement platformsAchievement;

  UserAchievements._internal() {
    // retrieve storage
    secureStorage.getWoodSingle().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        woodSingle = bool.parse(value);
      }
      createAchievementList();
    });
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
    secureStorage.getWoodDouble().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        woodDouble = bool.parse(value);
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
    secureStorage.getNightOwl().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        nightOwl = bool.parse(value);
      }
      createAchievementList();
    });
    secureStorage.getWingedWarrior().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        wingedWarrior = bool.parse(value);
      }
      createAchievementList();
    });
    secureStorage.getPlatforms().then((value) {
      totalAchievementsRetrieved += 1;
      if (value != null) {
        platforms = bool.parse(value);
      }
      createAchievementList();
    });
  }

  createAchievementList() {
    if (totalAchievementsRetrieved == totalNumberOfAchievements) {
      woodSingleAchievement = Achievement(
          achievementName: "woodSingle",
          imageName: "wood_single",
          tooltip: "got more than 10 points in single player",
          achieved: woodSingle
      );
      bronzeSingleAchievement = Achievement(
          achievementName: "bronzeSingle",
          imageName: "bronze_single",
          tooltip: "got more than 25 points in single player",
          achieved: bronzeSingle
      );
      silverSingleAchievement = Achievement(
          achievementName: "silverSingle",
          imageName: "silver_single",
          tooltip: "got more than 50 points in single player!",
          achieved: silverSingle
      );
      goldSingleAchievement = Achievement(
          achievementName: "goldSingle",
          imageName: "gold_single",
          tooltip: "got more than 100 points in single player!!!",
          achieved: goldSingle
      );
      woodDoubleAchievement = Achievement(
          achievementName: "woodDouble",
          imageName: "wood_double",
          tooltip: "got more than 10 points with 2 players",
          achieved: woodDouble
      );
      bronzeDoubleAchievement = Achievement(
          achievementName: "bronzeDouble",
          imageName: "bronze_double",
          tooltip: "got more than 25 points with 2 players",
          achieved: bronzeDouble
      );
      silverDoubleAchievement = Achievement(
          achievementName: "silverDouble",
          imageName: "silver_double",
          tooltip: "got more than 50 points with 2 players!",
          achieved: silverDouble
      );
      goldDoubleAchievement = Achievement(
          achievementName: "goldDouble",
          imageName: "gold_double",
          tooltip: "got more than 100 points with 2 players!!!",
          achieved: goldDouble
      );
      flutterOneAchievement = Achievement(
          achievementName: "flutterOne",
          imageName: "wings_one",
          tooltip: "You have fluttered your birds already more than a thousand times",
          achieved: flutterOne
      );
      flutterTwoAchievement = Achievement(
          achievementName: "flutterTwo",
          imageName: "wings_two",
          tooltip: "You have fluttered your birds already more than two thousand and five hundred times!",
          achieved: flutterTwo
      );
      flutterThreeAchievement = Achievement(
          achievementName: "flutterThree",
          imageName: "wings_three",
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
          imageName: "perseverance",
          tooltip: "You kept playing the game even after crashing 50 times in a single session!",
          achieved: perseverance
      );
      nightOwlAchievement = Achievement(
          achievementName: "nightOwl",
          imageName: "midnight",
          tooltip: "You scored more than 20 points in a single session between 12:00 AM and 3:00 AM!",
          achieved: nightOwl
      );
      wingedWarriorAchievement = Achievement(
          achievementName: "wingedWarrior",
          imageName: "winged_warrior",
          tooltip: "You have played Flutterbird for 7 days in a row!",
          achieved: wingedWarrior
      );
      platformsAchievement = Achievement(
          achievementName: "platforms",
          imageName: "platforms",
          tooltip: "You have played Flutterbird on the web at flutterbird.eu and also on IOS or Android!",
          achieved: platforms
      );
      allAchievementsAvailable = [
        woodSingleAchievement,
        bronzeSingleAchievement,
        silverSingleAchievement,
        goldSingleAchievement,
        woodDoubleAchievement,
        bronzeDoubleAchievement,
        silverDoubleAchievement,
        goldDoubleAchievement,
        flutterOneAchievement,
        flutterTwoAchievement,
        flutterThreeAchievement,
        pipesOneAchievement,
        pipesTwoAchievement,
        pipesThreeAchievement,
        perseveranceAchievement,
        nightOwlAchievement,
        wingedWarriorAchievement,
        platformsAchievement
      ];
    }
  }

  factory UserAchievements() {
    return _instance;
  }

  logout() {
    woodSingle = false;
    bronzeSingle = false;
    silverSingle = false;
    goldSingle = false;
    woodDouble = false;
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
    nightOwl = false;
    wingedWarrior = false;
    platforms = false;
    secureStorage.setWoodSingle("false");
    secureStorage.setBronzeSingle("false");
    secureStorage.setSilverSingle("false");
    secureStorage.setGoldSingle("false");
    secureStorage.setWoodDouble("false");
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
    secureStorage.setNightOwl("false");
    secureStorage.setWingedWarrior("false");
    secureStorage.setPlatforms("false");
    woodSingleAchievement.achieved = false;
    bronzeSingleAchievement.achieved = false;
    silverSingleAchievement.achieved = false;
    goldSingleAchievement.achieved = false;
    woodDoubleAchievement.achieved = false;
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
    nightOwlAchievement.achieved = false;
    wingedWarriorAchievement.achieved = false;
    platformsAchievement.achieved = false;
  }

  getWoodSingle() {
    return woodSingle;
  }
  achievedWoodSingle() async {
    this.woodSingle = true;
    woodSingleAchievement.achieved = true;
    secureStorage.setWoodSingle(woodSingle.toString());
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

  getWoodDouble() {
    return woodDouble;
  }
  achievedWoodDouble() async {
    woodDouble = true;
    woodDoubleAchievement.achieved = true;
    secureStorage.setWoodDouble(woodDouble.toString());
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

  getNightOwl() {
    return nightOwl;
  }
  achievedNightOwl() async {
    nightOwl = true;
    nightOwlAchievement.achieved = true;
    secureStorage.setNightOwl(nightOwl.toString());
  }

  getWingedWarrior() {
    return wingedWarrior;
  }
  achievedWingedWarrior() async {
    wingedWarrior = true;
    wingedWarriorAchievement.achieved = true;
    secureStorage.setWingedWarrior(wingedWarrior.toString());
  }

  getPlatforms() {
    return platforms;
  }
  setPlatforms(bool platforms) {
    this.platforms = platforms;
  }
  achievedPlatforms() async {
    platforms = true;
    justAchievedPlatforms = true;
    platformsAchievement.achieved = true;
    secureStorage.setPlatforms(platforms.toString());
  }

  checkPlatforms() {
    return justAchievedPlatforms;
  }
  platformsAchievementShown() {
    justAchievedPlatforms = false;
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
        woodSingle,
        bronzeSingle,
        silverSingle,
        goldSingle,
        woodDouble,
        bronzeDouble,
        silverDouble,
        goldDouble,
        flutterOne,
        flutterTwo,
        flutterThree,
        pipesOne,
        pipesTwo,
        pipesThree,
        perseverance,
        nightOwl,
        wingedWarrior,
        platforms
    );
  }

  bool _isNumeric(String? str) {
    if(str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  checkWingedWarrior(ScoreScreenChangeNotifier scoreScreenChangeNotifier) {
    secureStorage.getPreviousDay().then((value) {
      if (value == null) {
        // Set the previous day to today. We just store the day, that should be sufficient.
        secureStorage.setPreviousDay(DateTime.now().day.toString());
      } else {
        if (_isNumeric(value)) {
          int storedPreviousDay = int.parse(value);
          int currentDay = DateTime.now().day;
          int yesterday = DateTime.now().subtract(const Duration(days:1)).day;
          if (storedPreviousDay == currentDay) {
            // Do nothing, we already played today.
          } else {
            // It's a different day so we update the previous day so it can check it tomorrow.
            secureStorage.setPreviousDay(DateTime.now().day.toString());
            // the stored and previous day is different.
            // The stored has to be yesterday.
            // Otherwise the user played on a different day besides yesterday.
            if (storedPreviousDay == yesterday) {
              // We can increase the daysInARow counter
              secureStorage.getDaysInARow().then((value) {
                if (value== null) {
                  secureStorage.setDaysInARow("1");
                } else {
                  int daysInARow = int.parse(value) + 1;
                  secureStorage.setDaysInARow(daysInARow.toString());
                  if (daysInARow == 7) {
                    // 7 days in a row, you won the achievement.
                    achievedWingedWarrior();
                    scoreScreenChangeNotifier.addAchievement(wingedWarriorAchievement);
                    scoreScreenChangeNotifier.notify();
                  }
                }
              });
            } else {
              // The user did not play yesterday, so we reset the counter.
              // It's possible that the user plays once a month for 10 months
              // with the days being sequential such that it will get this
              // achievement. We don't really mind this edge case.
              secureStorage.setDaysInARow("1");
            }
          }
        } else {
          // If the previous day is not numeric, than something went wrong but we fix it here.
          secureStorage.setPreviousDay(DateTime.now().day.toString());
        }
      }
    });
  }
}

class Achievements {

  bool woodSingle = false;
  bool bronzeSingle = false;
  bool silverSingle = false;
  bool goldSingle = false;
  bool woodDouble = false;
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
  bool nightOwl = false;
  bool wingedWarrior = false;
  bool platforms = false;

  Achievements(this.woodSingle, this.bronzeSingle, this.silverSingle, this.goldSingle, this.woodDouble, this.bronzeDouble, this.silverDouble, this.goldDouble, this.flutterOne, this.flutterTwo, this.flutterThree, this.pipesOne, this.pipesTwo, this.pipesThree, this.perseverance, this.nightOwl, this.wingedWarrior, this.platforms);

  Achievements.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("wood_single")) {
      woodSingle = json["wood_single"];
    }
    if (json.containsKey("bronze_single")) {
      bronzeSingle = json["bronze_single"];
    }
    if (json.containsKey("silver_single")) {
      silverSingle = json["silver_single"];
    }
    if (json.containsKey("gold_single")) {
      goldSingle = json["gold_single"];
    }
    if (json.containsKey("wood_double")) {
      woodDouble = json["wood_double"];
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
    if (json.containsKey("night_owl")) {
      nightOwl = json["night_owl"];
    }
    if (json.containsKey("winged_warrior")) {
      wingedWarrior = json["winged_warrior"];
    }
    if (json.containsKey("platforms")) {
      platforms = json["platforms"];
    }
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{};

    if (woodSingle) {
      json['wood_single'] = woodSingle;
    }
    if (bronzeSingle) {
      json['bronze_single'] = bronzeSingle;
    }
    if (silverSingle) {
      json['silver_single'] = silverSingle;
    }
    if (goldSingle) {
      json['gold_single'] = goldSingle;
    }
    if (woodDouble) {
      json['wood_double'] = woodDouble;
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
    if (nightOwl) {
      json['night_owl'] = nightOwl;
    }
    if (wingedWarrior) {
      json['winged_warrior'] = wingedWarrior;
    }
    if (platforms) {
      json['platforms'] = platforms;
    }
    return json;
  }

  bool getWoodSingle() {
    return woodSingle;
  }
  setWoodSingle(bool woodSingle) {
    this.woodSingle = woodSingle;
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

  bool getWoodDouble() {
    return woodDouble;
  }
  setWoodDouble(bool woodDouble) {
    this.woodDouble = woodDouble;
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

  bool getNightOwl() {
    return nightOwl;
  }
  setNightOwl(bool nightOwl) {
    this.nightOwl = nightOwl;
  }

  bool getWingedWarrior() {
    return wingedWarrior;
  }
  setWingedWarrior(bool wingedWarrior) {
    this.wingedWarrior = wingedWarrior;
  }

  bool getPlatforms() {
    return platforms;
  }
  setPlatforms(bool platforms) {
    this.platforms = platforms;
  }
}
