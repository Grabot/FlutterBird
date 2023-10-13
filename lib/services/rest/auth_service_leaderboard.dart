import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/views/leader_board/Rank.dart';

import 'auth_api.dart';
import 'models/base_response.dart';


class AuthServiceLeaderboard {
  static AuthServiceLeaderboard? _instance;

  factory AuthServiceLeaderboard() => _instance ??= AuthServiceLeaderboard._internal();

  AuthServiceLeaderboard._internal();

  Future<BaseResponse> updateLeaderboardOnePlayer(int score) async {
    String endPoint = "update/leaderboard/one_player";
    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(<String, dynamic>{
          "score": score,
        }
      )
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }

  Future<List<Rank>?> getLeaderboardOnePlayer() async {
    print("getting leaderboard");
    String endPoint = "get/leaderboard/one_player";
    var response = await AuthApi().dio.get(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
    );

    Map<String, dynamic> json = response.data;
    if (json["result"]) {
      if (!json.containsKey("leaders")) {
        return null;
      } else {
        List<Rank> ranks = [];
        for (var test in json["leaders"]) {
          ranks.add(Rank.fromJson(test));
        }
        return ranks;
      }
    } else {
      return null;
    }
  }
}