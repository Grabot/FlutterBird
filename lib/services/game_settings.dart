import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/util/web_storage.dart';


class GameSettings extends ChangeNotifier {
  static final GameSettings _instance = GameSettings._internal();

  int birdType1 = 0;
  int birdType2 = 1;
  int backgroundType = 0;
  int pipeType = 0;
  int playerType = 0;

  bool sound = true;

  SecureStorage secureStorage = SecureStorage();

  GameSettings._internal() {
    // Retrieve game settings
    secureStorage.getPlayerType().then((value) {
      if (value != null) {
        int newPlayerType = int.parse(value);
        if (newPlayerType != playerType) {
          playerType = newPlayerType;
          notifyListeners();
        }
      }
    });
    secureStorage.getBirdType1().then((value) {
      if (value != null) {
        int newBirdType1 = int.parse(value);
        if (newBirdType1 != birdType1) {
          birdType1 = newBirdType1;
          notifyListeners();
        }
      }
    });
    secureStorage.getBirdType2().then((value) {
      if (value != null) {
        int newBirdType2 = int.parse(value);
        if (newBirdType2 != birdType2) {
          birdType2 = newBirdType2;
          notifyListeners();
        }
      }
    });
    secureStorage.getBackgroundType().then((value) {
      if (value != null) {
        int newBackgroundType = int.parse(value);
        if (newBackgroundType != backgroundType) {
          backgroundType = newBackgroundType;
          notifyListeners();
        }
      }
    });
    secureStorage.getPipeType().then((value) {
      if (value != null) {
        int newPipeType = int.parse(value);
        if (newPipeType != pipeType) {
          pipeType = newPipeType;
          notifyListeners();
        }
      }
    });
  }

  factory GameSettings() {
    return _instance;
  }

  notify() {
    notifyListeners();
  }

  setBirdType1(int birdType1) {
    this.birdType1 = birdType1;
    secureStorage.setBirdType1(birdType1.toString());
  }

  int getBirdType1() {
    return birdType1;
  }

  setBirdType2(int birdType2) {
    this.birdType2 = birdType2;
    secureStorage.setBirdType2(birdType2.toString());
  }

  int getBirdType2() {
    return birdType2;
  }

  setBackgroundType(int backgroundType) {
    this.backgroundType = backgroundType;
    secureStorage.setBackgroundType(backgroundType.toString());
  }

  int getBackgroundType() {
    return backgroundType;
  }

  setPipeType(int pipeType) {
    this.pipeType = pipeType;
    secureStorage.setPipeType(pipeType.toString());
  }

  int getPipeType() {
    return pipeType;
  }

  int getPlayerType() {
    return playerType;
  }

  setPlayerType(int playerType) {
    this.playerType = playerType;
    secureStorage.setPlayerType(playerType.toString());
  }

  setSound(bool sound) {
    this.sound = sound;
    secureStorage.setSound(sound.toString());
  }

  bool getSound() {
    return sound;
  }

  logout() {
    birdType1 = 0;
    birdType2 = 1;
    backgroundType = 0;
    pipeType = 0;
    playerType = 0;
    notifyListeners();
  }
}
