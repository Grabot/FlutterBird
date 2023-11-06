import 'package:flutter/material.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/game_settings.dart';
import 'package:flutter_bird/services/navigation_service.dart';
import 'package:flutter_bird/services/rest/auth_service_flutter_bird.dart';
import 'package:flutter_bird/services/rest/auth_service_login.dart';
import 'package:flutter_bird/services/rest/models/login_response.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/socket_services.dart';
import 'package:flutter_bird/services/user_achievements.dart';
import 'package:flutter_bird/services/user_score.dart';
import 'package:flutter_bird/views/user_interface/models/achievement.dart';
import 'package:flutter_bird/views/user_interface/profile/profile_box/profile_box.dart';
import 'package:flutter_bird/views/user_interface/profile/profile_box/profile_change_notifier.dart';
import 'package:oktoast/oktoast.dart';
import 'package:jwt_decode/jwt_decode.dart';

import 'web_storage.dart';

showToastMessage(String message) {
  showToast(
    message,
    duration: const Duration(milliseconds: 2000),
    position: ToastPosition.top,
    backgroundColor: Colors.white,
    radius: 1.0,
    textStyle: const TextStyle(fontSize: 30.0, color: Colors.black),
  );
}

ButtonStyle buttonStyle(bool active, MaterialColor buttonColor) {
  return ButtonStyle(
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return buttonColor.shade600;
          }
          if (states.contains(MaterialState.pressed)) {
            return buttonColor.shade300;
          }
          return null;
        },
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return active? buttonColor.shade800 : buttonColor;
          }),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          )
      )
  );
}

getScore(LoginResponse loginResponse, int userId) {
  UserScore userScore = UserScore();
  Score? score = loginResponse.getScore();
  if (score != null) {
    bool updateScore = false;

    if (score.getBestScoreSingleBird() > userScore.getBestScoreSingleBird()) {
      userScore.setBestScoreSingleBird(score.getBestScoreSingleBird());
    } else if (userScore.getBestScoreSingleBird() > score.getBestScoreSingleBird()) {
      score.setBestScoreSingleBird(userScore.getBestScoreSingleBird());
      updateScore = true;
    }
    if (score.getBestScoreDoubleBird() > userScore.getBestScoreDoubleBird()) {
      userScore.setBestScoreDoubleBird(score.getBestScoreDoubleBird());
    } else if (userScore.getBestScoreDoubleBird() > score.getBestScoreDoubleBird()) {
      score.setBestScoreDoubleBird(userScore.getBestScoreDoubleBird());
      updateScore = true;
    }
    if (score.getTotalFlutters() > userScore.getTotalFlutters()) {
      userScore.setTotalFlutters(score.getTotalFlutters());
    } else if (userScore.getTotalFlutters() > score.getTotalFlutters()) {
      score.setTotalFlutters(userScore.getTotalFlutters());
      updateScore = true;
    }
    if (score.getTotalPipesCleared() > userScore.getTotalPipesCleared()) {
      userScore.setTotalPipesCleared(score.getTotalPipesCleared());
    } else if (userScore.getTotalPipesCleared() > score.getTotalPipesCleared()) {
      score.setTotalPipesCleared(userScore.getTotalPipesCleared());
      updateScore = true;
    }
    if (score.getTotalGames() > userScore.getTotalGames()) {
      userScore.setTotalGames(score.getTotalGames());
    } else if (userScore.getTotalGames() > score.getTotalGames()) {
      score.setTotalGames(userScore.getTotalGames());
      updateScore = true;
    }

    if (updateScore) {
      // TODO: Add double bird score once it's on the score object
      AuthServiceFlutterBird().updateUserScore(score.getBestScoreSingleBird(), score.getBestScoreDoubleBird(), score).then((result) {
        if (result.getResult()) {
          // we have updated the score in the db. Do nothing.
        }
      });
    }
  }
}

getAchievements(LoginResponse loginResponse, int userId) {
  UserAchievements userAchievements = UserAchievements();
  Achievements? achievements = loginResponse.getAchievements();
  if (achievements != null) {
    bool updateAchievements = false;
    if (achievements.getBronzeSingle() && !userAchievements.getBronzeSingle()) {
      userAchievements.achievedBronzeSingle();
    } else if (!achievements.getBronzeSingle() && userAchievements.getBronzeSingle()) {
      achievements.setBronzeSingle(userAchievements.getBronzeSingle());
      updateAchievements = true;
    }
    if (achievements.getSilverSingle() && !userAchievements.getSilverSingle()) {
      userAchievements.achievedSilverSingle();
    } else if (!achievements.getSilverSingle() && userAchievements.getSilverSingle()) {
      achievements.setSilverSingle(userAchievements.getSilverSingle());
      updateAchievements = true;
    }
    if (achievements.getGoldSingle() && !userAchievements.getGoldSingle()) {
      userAchievements.achievedGoldSingle();
    } else if (!achievements.getGoldSingle() && userAchievements.getGoldSingle()) {
      achievements.setGoldSingle(userAchievements.getGoldSingle());
      updateAchievements = true;
    }
    if (achievements.getBronzeDouble() && !userAchievements.getBronzeDouble()) {
      userAchievements.achievedBronzeDouble();
    } else if (!achievements.getBronzeDouble() && userAchievements.getBronzeDouble()) {
      achievements.setBronzeDouble(userAchievements.getBronzeDouble());
      updateAchievements = true;
    }
    if (achievements.getSilverDouble() && !userAchievements.getSilverDouble()) {
      userAchievements.achievedSilverDouble();
    } else if (!achievements.getSilverDouble() && userAchievements.getSilverDouble()) {
      achievements.setSilverDouble(userAchievements.getSilverDouble());
      updateAchievements = true;
    }
    if (achievements.getGoldDouble() && !userAchievements.getGoldDouble()) {
      userAchievements.achievedGoldDouble();
    } else if (!achievements.getGoldDouble() && userAchievements.getGoldDouble()) {
      achievements.setGoldDouble(userAchievements.getGoldDouble());
      updateAchievements = true;
    }

    if (updateAchievements) {
      AuthServiceFlutterBird().updateAchievements(achievements).then((result) {
        if (result.getResult()) {
          // we have updated the score in the db. Do nothing.
        }
      });
    }
  }
}

successfulLogin(LoginResponse loginResponse) async {
  SecureStorage secureStorage = SecureStorage();
  Settings settings = Settings();

  User? user = loginResponse.getUser();
  if (user != null) {
    settings.setUser(user);
    if (user.getAvatar() != null) {
      settings.setAvatar(user.getAvatar()!);
    }
    getScore(loginResponse, user.id);
    getAchievements(loginResponse, user.id);
    SocketServices().login(user.id);
  }

  String? accessToken = loginResponse.getAccessToken();
  if (accessToken != null) {
    // the access token will be set in memory and local storage.
    settings.setAccessToken(accessToken);
    settings.setAccessTokenExpiration(Jwt.parseJwt(accessToken)['exp']);
    await secureStorage.setAccessToken(accessToken);
  }

  String? refreshToken = loginResponse.getRefreshToken();
  if (refreshToken != null) {
    // the refresh token will only be set in memory.
    settings.setRefreshToken(refreshToken);
    settings.setRefreshTokenExpiration(Jwt.parseJwt(refreshToken)['exp']);
    await secureStorage.setRefreshToken(refreshToken);
  }

  settings.setLoggingIn(false);
  ProfileChangeNotifier().notify();
  settings.updateRanks();
}

TextStyle simpleTextStyle(double fontSize) {
  return TextStyle(color: Colors.white, fontSize: fontSize);
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.white54,
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white54),
      ));
}

bool emailValid(String possibleEmail) {
  return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(possibleEmail);
}

logoutUser(Settings settings, NavigationService navigationService) async {
  if (settings.getUser() != null) {
    await AuthServiceLogin().logout();  // we assume it will work, but it doesn't matter if it doesn't
    SocketServices().logout(settings.getUser()!.id);
  }
  ProfileChangeNotifier().setProfileVisible(false);
  settings.logout();
  SecureStorage().logout();
  UserScore().logout();
  UserAchievements().logout();
  GameSettings().logout();
}

Widget expandedText(double width, String text, double fontSize, bool bold) {
  return Container(
    width: width,
    child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ]
    ),
  );
}

Color overviewColour(int state, Color colour0, Color colour1, Color colour2) {
  if (state == 0) {
    return colour0;
  } else if (state == 1) {
    return colour1;
  } else {
    return colour2;
  }
}

int getRankingSelection(bool onePlayer, int currentScore, Settings settings) {
  if (onePlayer) {
    if (settings.rankingsOnePlayerAll.length >= 10) {
      // If the user has a larger score than what is currently in the top 10
      // then they are in the top 10. We return "4" to indicate the all leaderboard.
      if (currentScore > settings.rankingsOnePlayerAll[9].getScore()) {
        return 4;
      }
    } else {
      // If there aren't 10 scores in the leaderboard than the user has made it into the top 10.
      return 4;
    }
    if (settings.rankingsOnePlayerYear.length >= 10) {
      if (currentScore > settings.rankingsOnePlayerYear[9].getScore()) {
        return 3;
      }
    } else {
      return 3;
    }
    if (settings.rankingsOnePlayerMonth.length >= 10) {
      if (currentScore > settings.rankingsOnePlayerMonth[9].getScore()) {
        return 2;
      }
    } else {
      return 2;
    }
    if (settings.rankingsOnePlayerWeek.length >= 10) {
      if (currentScore > settings.rankingsOnePlayerWeek[9].getScore()) {
        return 1;
      }
    } else {
      return 1;
    }
    if (settings.rankingsOnePlayerDay.length >= 10) {
      if (currentScore > settings.rankingsOnePlayerDay[9].getScore()) {
        return 0;
      }
    } else {
      return 0;
    }
  } else {
    if (settings.rankingsTwoPlayerAll.length >= 10) {
      if (currentScore > settings.rankingsTwoPlayerAll[9].getScore()) {
        return 4;
      }
    } else {
      return 4;
    }
    if (settings.rankingsTwoPlayerYear.length >= 10) {
      if (currentScore > settings.rankingsTwoPlayerYear[9].getScore()) {
        return 3;
      }
    } else {
      return 3;
    }
    if (settings.rankingsTwoPlayerMonth.length >= 10) {
      if (currentScore > settings.rankingsTwoPlayerMonth[9].getScore()) {
        return 2;
      }
    } else {
      return 2;
    }
    if (settings.rankingsTwoPlayerWeek.length >= 10) {
      if (currentScore > settings.rankingsTwoPlayerWeek[9].getScore()) {
        return 1;
      }
    } else {
      return 1;
    }
    if (settings.rankingsTwoPlayerDay.length >= 10) {
      if (currentScore > settings.rankingsTwoPlayerDay[9].getScore()) {
        return 0;
      }
    } else {
      return 0;
    }
  }
  return -1;
}
