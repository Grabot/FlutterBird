import 'package:flutter/material.dart';


class ProfileChangeNotifier extends ChangeNotifier {

  bool showProfile = false;
  bool showProfileOverview = true;

  static final ProfileChangeNotifier _instance = ProfileChangeNotifier._internal();

  ProfileChangeNotifier._internal();

  factory ProfileChangeNotifier() {
    return _instance;
  }

  setProfileVisible(bool visible) {
    showProfile = visible;
    notifyListeners();
  }

  getProfileVisible() {
    return showProfile;
  }

  setProfileOverviewVisible(bool visible) {
    showProfileOverview = visible;
    notifyListeners();
  }

  getProfileOverviewVisible() {
    return showProfileOverview;
  }

  notify() {
    notifyListeners();
  }

}
