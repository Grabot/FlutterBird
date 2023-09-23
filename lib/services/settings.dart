import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/models/user.dart';


class Settings extends ChangeNotifier {
  static final Settings _instance = Settings._internal();

  String accessToken = "";
  String refreshToken = "";
  int accessTokenExpiration = 0;
  int refreshTokenExpiration = 0;

  User? user;

  // String? avatar;
  Uint8List? avatar;

  bool loggingIn = false;

  int highScore = 0;

  Settings._internal() {
    if (kIsWeb) {

    }
  }

  factory Settings() {
    return _instance;
  }

  notify() {
    notifyListeners();
  }
  
  setUser(User user) {
    this.user = user;
  }

  User? getUser() {
    return user;
  }

  setAccessToken(String accessToken) {
    this.accessToken = accessToken;
  }

  String getAccessToken() {
    return accessToken;
  }

  setRefreshToken(String refreshToken) {
    this.refreshToken = refreshToken;
  }

  String getRefreshToken() {
    return refreshToken;
  }

  setAccessTokenExpiration(int accessTokenExpiration) {
    this.accessTokenExpiration = accessTokenExpiration;
  }

  int getAccessTokenExpiration() {
    return accessTokenExpiration;
  }

  setRefreshTokenExpiration(int refreshTokenExpiration) {
    this.refreshTokenExpiration = refreshTokenExpiration;
  }

  int getRefreshTokenExpiration() {
    return refreshTokenExpiration;
  }

  setLoggingIn(bool loggingIn) {
    this.loggingIn = loggingIn;
  }

  bool getLoggingIn() {
    return loggingIn;
  }

  logout() {
    accessToken = "";
    refreshToken = "";
    accessTokenExpiration = 0;
    user = null;
    avatar = null;
    loggingIn = false;
  }

  setAvatar(Uint8List avatar) {
    this.avatar = avatar;
  }

  Uint8List? getAvatar() {
    return avatar;
  }

  int getHighScore() {
    return highScore;
  }

  setHighScore(int highScore) {
    this.highScore = highScore;
  }
}