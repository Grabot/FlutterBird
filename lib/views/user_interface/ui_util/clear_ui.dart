import 'package:flutter/material.dart';
import 'package:flutter_bird/views/user_interface/change_avatar_box/change_avatar_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/loading_box/loading_box_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/login_screen/login_screen_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/profile/profile_box/profile_change_notifier.dart';


class ClearUI extends ChangeNotifier {

  static final ClearUI _instance = ClearUI._internal();

  ClearUI._internal();

  factory ClearUI() {
    return _instance;
  }

  isUiElementVisible() {
    if (ProfileChangeNotifier().getProfileVisible()
        || ChangeAvatarChangeNotifier().getChangeAvatarVisible()
        || LoadingBoxChangeNotifier().getLoadingBoxVisible()
        || LoginScreenChangeNotifier().getLoginScreenVisible()
    ) {
      return true;
    }
    return false;
  }

  clearUserInterfaces() {
    if (ChangeAvatarChangeNotifier().getChangeAvatarVisible()) {
      ChangeAvatarChangeNotifier().setChangeAvatarVisible(false);
    }
    if (LoadingBoxChangeNotifier().getLoadingBoxVisible()) {
      LoadingBoxChangeNotifier().setLoadingBoxVisible(false);
    }
    if (ProfileChangeNotifier().getProfileVisible()) {
      ProfileChangeNotifier().setProfileVisible(false);
    }
    if (LoginScreenChangeNotifier().getLoginScreenVisible()) {
      LoginScreenChangeNotifier().setLoginScreenVisible(false);
    }
  }
}
