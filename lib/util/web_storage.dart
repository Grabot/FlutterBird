import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class SecureStorage {

  final storage = const FlutterSecureStorage();

  final String _keyAccessToken = 'accessToken';
  final String _keyRefreshToken = 'refreshToken';

  Future setAccessToken(String accessToken) async {
    await storage.write(key: _keyAccessToken, value: accessToken);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: _keyAccessToken);
  }

  Future setRefreshToken(String refreshToken) async {
    await storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await storage.read(key: _keyRefreshToken);
  }

  final String _keyBestScore = 'bestScore';
  final String _keyTotalFluttersToken = 'totalFlutterToken';
  final String _keyTotalPipesToken = 'totalPipesToken';
  final String _keyTotalGamesToken = 'totalGamesToken';

  Future setTotalFlutters(String totalFlutters) async {
    await storage.write(key: _keyTotalFluttersToken, value: totalFlutters);
  }

  Future<String?> getTotalFlutters() async {
    return await storage.read(key: _keyTotalFluttersToken);
  }

  Future setTotalPipes(String totalPipes) async {
    await storage.write(key: _keyTotalPipesToken, value: totalPipes);
  }

  Future<String?> getTotalPipes() async {
    return await storage.read(key: _keyTotalPipesToken);
  }

  Future setTotalGames(String totalGames) async {
    await storage.write(key: _keyTotalGamesToken, value: totalGames);
  }

  Future<String?> getTotalGames() async {
    return await storage.read(key: _keyTotalGamesToken);
  }

  Future setBestScore(String bestScore) async {
    await storage.write(key: _keyBestScore, value: bestScore);
  }

  Future<String?> getBestScore() async {
    return await storage.read(key: _keyBestScore);
  }

  final String _keyBirdType1 = 'birdType1';
  final String _keyBirdType2 = 'birdType2';
  final String _keyBackgroundType = 'backgroundType';
  final String _keyPipeType = 'pipeType';
  final String _keyPlayerType = 'playerType';
  final String _keySound = 'sound';

  Future setBirdType1(String birdType1) async {
    await storage.write(key: _keyBirdType1, value: birdType1);
  }

  Future<String?> getBirdType1() async {
    return await storage.read(key: _keyBirdType1);
  }

  Future setBirdType2(String birdType2) async {
    await storage.write(key: _keyBirdType2, value: birdType2);
  }

  Future<String?> getBirdType2() async {
    return await storage.read(key: _keyBirdType2);
  }

  Future setBackgroundType(String backgroundType) async {
    await storage.write(key: _keyBackgroundType, value: backgroundType);
  }

  Future<String?> getBackgroundType() async {
    return await storage.read(key: _keyBackgroundType);
  }

  Future setPipeType(String pipeType) async {
    await storage.write(key: _keyPipeType, value: pipeType);
  }

  Future<String?> getPipeType() async {
    return await storage.read(key: _keyPipeType);
  }

  Future setPlayerType(String playerType) async {
    await storage.write(key: _keyPlayerType, value: playerType);
  }

  Future<String?> getPlayerType() async {
    return await storage.read(key: _keyPlayerType);
  }

  Future setSound(String sound) async {
    await storage.write(key: _keySound, value: sound);
  }

  Future<String?> getSound() async {
    return await storage.read(key: _keySound);
  }

  Future logout() async {
    await storage.write(key: _keyAccessToken, value: null);
    await storage.write(key: _keyRefreshToken, value: null);

    await storage.write(key: _keyBestScore, value: null);
    await storage.write(key: _keyTotalFluttersToken, value: null);
    await storage.write(key: _keyTotalPipesToken, value: null);
    await storage.write(key: _keyTotalGamesToken, value: null);

    await storage.write(key: _keyBirdType1, value: null);
    await storage.write(key: _keyBirdType2, value: null);
    await storage.write(key: _keyBackgroundType, value: null);
    await storage.write(key: _keyPipeType, value: null);
    await storage.write(key: _keyPlayerType, value: null);
    await storage.write(key: _keySound, value: null);
  }

}
