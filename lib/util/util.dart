import 'package:flutter/material.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/navigation_service.dart';
import 'package:flutter_bird/services/rest/auth_service_flutter_bird.dart';
import 'package:flutter_bird/services/rest/auth_service_login.dart';
import 'package:flutter_bird/services/rest/models/login_response.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/socket_services.dart';
import 'package:flutter_bird/constants/route_paths.dart' as routes;
import 'package:flutter_bird/services/user_score.dart';
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

    if (score.getBestScore() > userScore.getBestScore()) {
      userScore.setBestScore(score.getBestScore());
    } else if (userScore.getBestScore() > score.getBestScore()){
      score.setBestScore(userScore.getBestScore());
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
      AuthServiceFlutterBird().updateUserScore(score).then((result) {
        if (result.getResult()) {
          print("we have updated the score in the db");
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
  SecureStorage().logout().then((value) {
    navigationService.navigateTo(routes.HomeRoute, arguments: {'message': "Logged out"});
  });
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
