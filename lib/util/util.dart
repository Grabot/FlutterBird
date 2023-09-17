import 'package:flutter/material.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/rest/models/login_response.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/socket_services.dart';
import 'package:flutter_bird/views/user_interface/chat_box/chat_messages.dart';
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

successfulLogin(LoginResponse loginResponse) async {
  SecureStorage secureStorage = SecureStorage();
  Settings settings = Settings();

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

  User? user = loginResponse.getUser();
  if (user != null) {
    settings.setUser(user);
    if (user.getAvatar() != null) {
      settings.setAvatar(user.getAvatar()!);
    }
    SocketServices().login(user.id);
  }
  ChatMessages().login();
  settings.setLoggingIn(false);
  // ProfileChangeNotifier().notify();
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
