import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/util/web_storage.dart';
import 'package:flutter_bird/views/user_interface/profile/profile_box/profile_change_notifier.dart';


class GameSettings extends ChangeNotifier {
  static final GameSettings _instance = GameSettings._internal();

  int birdType1 = 0;
  int birdType2 = 1;
  int pipeType = 0;
  int playerType = 0;

  int storageLoaded = 0;

  bool sound = true;
  bool buttonVisibility = true;

  SecureStorage secureStorage = SecureStorage();

  GameSettings._internal() {
    // Retrieve game settings
    secureStorage.getPlayerType().then((value) {
      if (value != null) {
        int newPlayerType = int.parse(value);
        if (newPlayerType != playerType) {
          playerType = newPlayerType;
        }
      }
      storageLoaded += 1;
      checkIfShouldNotify();
    });
    secureStorage.getBirdType1().then((value) {
      if (value != null) {
        int newBirdType1 = int.parse(value);
        if (newBirdType1 != birdType1) {
          birdType1 = newBirdType1;
        }
      }
      storageLoaded += 1;
      checkIfShouldNotify();
    });
    secureStorage.getBirdType2().then((value) {
      if (value != null) {
        int newBirdType2 = int.parse(value);
        if (newBirdType2 != birdType2) {
          birdType2 = newBirdType2;
        }
      }
      storageLoaded += 1;
      checkIfShouldNotify();
    });
    secureStorage.getPipeType().then((value) {
      if (value != null) {
        int newPipeType = int.parse(value);
        if (newPipeType != pipeType) {
          pipeType = newPipeType;
        }
      }
      storageLoaded += 1;
      checkIfShouldNotify();
    });
    secureStorage.getSound().then((value) {
      if (value != null) {
        bool soundType = bool.parse(value);
        if (soundType != sound) {
          sound = soundType;
        }
      }
      storageLoaded += 1;
      checkIfShouldNotify();
    });
    secureStorage.getButtonVisibility().then((value) {
      if (value != null) {
        bool buttonVisibilityType = bool.parse(value);
        if (buttonVisibilityType != buttonVisibility) {
          buttonVisibility = buttonVisibilityType;
          ProfileChangeNotifier().setProfileOverviewVisible(buttonVisibility);
        }
      }
      storageLoaded += 1;
      checkIfShouldNotify();
    });
  }

  checkIfShouldNotify() {
    if (storageLoaded == 6) {
      notify();
    }
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

  setButtonVisibility(bool buttonVisibility) {
    this.buttonVisibility = buttonVisibility;
    secureStorage.setButtonVisibility(buttonVisibility.toString());
  }

  bool getButtonVisibility() {
    return buttonVisibility;
  }

  logout() {
    birdType1 = 0;
    birdType2 = 1;
    pipeType = 0;
    playerType = 0;
    sound = false;
    buttonVisibility = false;
    notifyListeners();
  }
}
