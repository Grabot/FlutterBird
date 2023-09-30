import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/util/web_storage.dart';
import 'package:isolated_worker/js_isolated_worker.dart';


class GameSettings extends ChangeNotifier {
  static final GameSettings _instance = GameSettings._internal();

  int birdType = 0;
  int backgroundType = 0;
  int pipeType = 0;

  SecureStorage secureStorage = SecureStorage();

  GameSettings._internal() {
    // Retrieve game settings
    secureStorage.getBirdType().then((value) {
      if (value != null) {
        int newBirdType = int.parse(value);
        if (newBirdType != birdType) {
          birdType = newBirdType;
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

  setBirdType(int birdType) {
    this.birdType = birdType;
    secureStorage.setBirdType(birdType.toString());
  }

  int getBirdType() {
    return birdType;
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
}
