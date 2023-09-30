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

  Future logout() async {
    await storage.write(key: _keyAccessToken, value: null);
    await storage.write(key: _keyRefreshToken, value: null);
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

  final String _keyBirdType = 'birdType';
  final String _keyBackgroundType = 'backgroundType';
  final String _keyPipeType = 'pipeType';

  Future setBirdType(String birdType) async {
    await storage.write(key: _keyBirdType, value: birdType);
  }

  Future<String?> getBirdType() async {
    return await storage.read(key: _keyBirdType);
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
}
