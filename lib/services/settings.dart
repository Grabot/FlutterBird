import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/rest/auth_service_leaderboard.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/util/web_storage.dart';
import 'package:flutter_bird/views/user_interface/models/rank.dart';
import 'package:isolated_worker/js_isolated_worker.dart';
import 'package:flutter_bird/constants/route_paths.dart' as routes;
import 'package:jwt_decode/jwt_decode.dart';

import 'rest/auth_service_login.dart';
import 'rest/models/login_response.dart';


class Settings extends ChangeNotifier {
  static final Settings _instance = Settings._internal();

  String accessToken = "";
  String refreshToken = "";
  int accessTokenExpiration = 0;
  int refreshTokenExpiration = 0;

  User? user;

  Uint8List? avatar;

  bool loggingIn = false;

  bool rankingOnePlayerRetrieved = false;
  List<Rank> rankingsOnePlayerDay = [];
  List<Rank> rankingsOnePlayerWeek = [];
  List<Rank> rankingsOnePlayerMonth = [];
  List<Rank> rankingsOnePlayerYear = [];
  List<Rank> rankingsOnePlayerAll = [];

  bool rankingTwoPlayerRetrieved = false;
  List<Rank> rankingsTwoPlayerDay = [];
  List<Rank> rankingsTwoPlayerWeek = [];
  List<Rank> rankingsTwoPlayerMonth = [];
  List<Rank> rankingsTwoPlayerYear = [];
  List<Rank> rankingsTwoPlayerAll = [];

  Settings._internal() {
    if (kIsWeb) {
      JsIsolatedWorker().importScripts(['crop/crop_web.js']).then((value) {
        // script imported
      });
    }
    // check for stored tokens to automatically log in.
    String path = Uri.base.path;
    if (path != routes.BirdAccessRoute || path != routes.PasswordResetRoute) {
      WidgetsFlutterBinding.ensureInitialized();
      WidgetsBinding.instance.addPostFrameCallback((_){
        loginCheck(path);
        getLeaderBoardsOnePlayer();
      });
    }
  }
  Future<bool> accessTokenLogin(String accessToken) async {
    try {
      LoginResponse loginResponse = await AuthServiceLogin().getTokenLogin(accessToken);
      if (loginResponse.getResult()) {
        return true;
      } else if (!loginResponse.getResult()) {
        // access token NOT valid!
        return false;
      }
    } catch(error) {
      showToastMessage(error.toString());
    }
    return false;
  }

  Future<bool> refreshTokenLogin(String accessToken, String refreshToken) async {
    try {
      LoginResponse loginResponse = await AuthServiceLogin().getRefresh(accessToken, refreshToken);
      if (loginResponse.getResult()) {
        return true;
      } else if (!loginResponse.getResult()) {
        // refresh token NOT valid!
        return false;
      }
    } catch(error) {
      showToastMessage(error.toString());
    }
    return false;
  }

  loginCheck(String path) async {
    SecureStorage _secureStorage = SecureStorage();
    String? accessToken = await _secureStorage.getAccessToken();
    int current = (DateTime.now().millisecondsSinceEpoch / 1000).round();

    if (accessToken != null && accessToken != "") {
      int expiration = Jwt.parseJwt(accessToken)['exp'];
      if ((expiration - current) > 0) {
        // token valid! Attempt to login with it.
        bool accessTokenSuccessful = await accessTokenLogin(accessToken);
        if (accessTokenSuccessful) {
          return;
        }
      }

      // If there is an access token but it is not valid we might be able to refresh the tokens.
      String? refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken != null && refreshToken != "") {
        int expirationRefresh = Jwt.parseJwt(refreshToken)['exp'];
        if ((expirationRefresh - current) > 0) {
          // refresh token valid! Attempt to refresh tokens and login with it.
          bool refreshTokenSuccessful = await refreshTokenLogin(accessToken, refreshToken);
          if (refreshTokenSuccessful) {
            return;
          }
        }
      }
    }
  }

  getLeaderBoardsOnePlayer() {
    if (rankingOnePlayerRetrieved) {
      return;
    }
    AuthServiceLeaderboard().getLeaderboardOnePlayer().then((value) {
      if (value != null) {
        rankingOnePlayerRetrieved = true;
        DateTime now = DateTime.now();
        DateTime dayAgo = now.subtract(const Duration(days: 1));
        DateTime weekAgo = now.subtract(const Duration(days: 7));
        DateTime monthAgo = now.subtract(const Duration(days: 31));
        DateTime yearAgo = now.subtract(const Duration(days: 365));
        for (Rank rank in value) {
          if (rank.timestamp.isAfter(dayAgo)) {
            rankingsOnePlayerDay.add(rank);
          }
          if (rank.timestamp.isAfter(weekAgo)) {
            rankingsOnePlayerWeek.add(rank);
          }
          if (rank.timestamp.isAfter(monthAgo)) {
            rankingsOnePlayerMonth.add(rank);
          }
          if (rank.timestamp.isAfter(yearAgo)) {
            rankingsOnePlayerYear.add(rank);
          }
          rankingsOnePlayerAll.add(rank);
        }
        // Sort the lists from high to low.
        sortList(rankingsOnePlayerDay);
        sortList(rankingsOnePlayerWeek);
        sortList(rankingsOnePlayerMonth);
        sortList(rankingsOnePlayerYear);
        sortList(rankingsOnePlayerAll);
        updateRanks();
        notifyListeners();
      }
    });
  }

  getLeaderBoardsTwoPlayer() {
    if (rankingTwoPlayerRetrieved) {
      return;
    }
    AuthServiceLeaderboard().getLeaderboardTwoPlayers().then((value) {
      if (value != null) {
        rankingTwoPlayerRetrieved = true;
        DateTime now = DateTime.now();
        DateTime dayAgo = now.subtract(const Duration(days: 1));
        DateTime weekAgo = now.subtract(const Duration(days: 7));
        DateTime monthAgo = now.subtract(const Duration(days: 31));
        DateTime yearAgo = now.subtract(const Duration(days: 365));
        for (Rank rank in value) {
          if (rank.timestamp.isAfter(dayAgo)) {
            rankingsTwoPlayerDay.add(rank);
          }
          if (rank.timestamp.isAfter(weekAgo)) {
            rankingsTwoPlayerWeek.add(rank);
          }
          if (rank.timestamp.isAfter(monthAgo)) {
            rankingsTwoPlayerMonth.add(rank);
          }
          if (rank.timestamp.isAfter(yearAgo)) {
            rankingsTwoPlayerYear.add(rank);
          }
          rankingsTwoPlayerAll.add(rank);
        }
        // Sort the lists from high to low.
        sortList(rankingsTwoPlayerDay);
        sortList(rankingsTwoPlayerWeek);
        sortList(rankingsTwoPlayerMonth);
        sortList(rankingsTwoPlayerYear);
        sortList(rankingsTwoPlayerAll);
        updateRanks();
        notifyListeners();
      }
    });
  }

  sortList(List<Rank> listToSort) {
    listToSort.sort((a, b) {
      int compare = b.score.compareTo(a.score);
      if (compare == 0) {
        return a.timestamp.compareTo(b.timestamp);
      } else {
        return compare;
      }
    });
  }

  updateLeaderboard(Rank newRank, bool onePlayer) {
    if (user != null) {
      if (newRank.getUserId() == user!.getId()) {
        newRank.setMe(true);
      }
    }
    if (onePlayer) {
      // The new rank will be just achieved, so add it to all the lists.
      rankingsOnePlayerDay.add(newRank);
      rankingsOnePlayerWeek.add(newRank);
      rankingsOnePlayerMonth.add(newRank);
      rankingsOnePlayerYear.add(newRank);
      rankingsOnePlayerAll.add(newRank);
      sortList(rankingsOnePlayerDay);
      sortList(rankingsOnePlayerWeek);
      sortList(rankingsOnePlayerMonth);
      sortList(rankingsOnePlayerYear);
      sortList(rankingsOnePlayerAll);
      notifyListeners();
    } else {
      rankingsTwoPlayerDay.add(newRank);
      rankingsTwoPlayerWeek.add(newRank);
      rankingsTwoPlayerMonth.add(newRank);
      rankingsTwoPlayerYear.add(newRank);
      rankingsTwoPlayerAll.add(newRank);
      sortList(rankingsTwoPlayerDay);
      sortList(rankingsTwoPlayerWeek);
      sortList(rankingsTwoPlayerMonth);
      sortList(rankingsTwoPlayerYear);
      sortList(rankingsTwoPlayerAll);
      notifyListeners();
    }
  }

  checkMeRankings(List rankList, int meId) {
    for (Rank rank in rankList) {
      if (rank.getUserId() == meId) {
        rank.setMe(true);
      }
    }
  }

  updateRanks() {
    if (user != null) {
      checkMeRankings(rankingsOnePlayerDay, user!.getId());
      checkMeRankings(rankingsOnePlayerWeek, user!.getId());
      checkMeRankings(rankingsOnePlayerMonth, user!.getId());
      checkMeRankings(rankingsOnePlayerYear, user!.getId());
      checkMeRankings(rankingsOnePlayerAll, user!.getId());
      checkMeRankings(rankingsTwoPlayerDay, user!.getId());
      checkMeRankings(rankingsTwoPlayerWeek, user!.getId());
      checkMeRankings(rankingsTwoPlayerMonth, user!.getId());
      checkMeRankings(rankingsTwoPlayerYear, user!.getId());
      checkMeRankings(rankingsTwoPlayerAll, user!.getId());
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
}
