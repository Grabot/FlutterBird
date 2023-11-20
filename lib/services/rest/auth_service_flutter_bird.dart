import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bird/services/user_achievements.dart';
import 'package:flutter_bird/services/user_score.dart';
import 'auth_api.dart';
import 'models/base_response.dart';


class AuthServiceFlutterBird {
  static AuthServiceFlutterBird? _instance;

  factory AuthServiceFlutterBird() => _instance ??= AuthServiceFlutterBird._internal();

  AuthServiceFlutterBird._internal();

  Future<BaseResponse> getUserScore() async {
    String endPoint = "score/get";
    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(<String, dynamic>{
        }
        )
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }

  Future<BaseResponse> updateUserScore(int? singleBirdScore, int? doubleBirdScore, Score score) async {
    String endPoint = "score/update";
    // We'll find the user using the token.
    Map<String, dynamic> data = {
      if (singleBirdScore != null) "best_score_single_bird": singleBirdScore,
      if (doubleBirdScore != null) "best_score_double_bird": doubleBirdScore,
      "total_flutters": score.getTotalFlutters(),
      "total_pipes_cleared": score.getTotalPipesCleared(),
      "total_games": score.getTotalGames(),
    };

    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(data)
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }

  Future<BaseResponse> updateAchievements(Achievements achievements) async {
    String endPoint = "achievements/update";
    var response = await AuthApi().dio.post(endPoint,
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: jsonEncode(<String, dynamic>{
          "achievements_dict": achievements.toJson(),
        }
      )
    );

    BaseResponse baseResponse = BaseResponse.fromJson(response.data);
    return baseResponse;
  }
}
