import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/locator.dart';
import 'package:flutter_bird/views/user_interface/game_settings/game_settings_button/game_settings_button.dart';
import 'package:flutter_bird/views/user_interface/login_screen/login_screen.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_bird/constants/route_paths.dart' as routes;
import 'services/game_settings.dart';
import 'services/navigation_service.dart';
import 'services/settings.dart';
import 'services/user_score.dart';
import 'views/user_interface/change_avatar_box/change_avatar_box.dart';
import 'views/user_interface/game_settings/game_settings_box/game_settings_box.dart';
import 'views/user_interface/profile/profile_box/profile_box.dart';
import 'views/user_interface/profile/profile_overview/profile_overview.dart';
import 'views/user_interface/score_screen/score_screen.dart';

Future<void> main() async {
  setPathUrlStrategy();
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();

  // initialize the settings and users score singleton
  Settings();
  GameSettings();
  UserScore();
  Flame.images.loadAll(<String>[]);

  FocusNode gameFocus = FocusNode();

  final game = FlutterBird(gameFocus);

  Widget gameWidget = Scaffold(
      body: GameWidget(
        focusNode: gameFocus,
        game: game,
        overlayBuilderMap: const {
          'scoreScreen': _scoreScreenBuilder,
          'profileBox': _profileBoxBuilder,
          'profileOverview': _profileOverviewBuilder,
          'loginScreen': _loginScreenBuilder,
          'changeAvatar': _changeAvatarBoxBuilder,
          'gameSettingsButton': _gameSettingsButtonBuilder,
          'gameSettingsBox': _gameSettingsBoxBuilder,
        },
        initialActiveOverlays: const [
          'scoreScreen',
          'profileBox',
          'profileOverview',
          'loginScreen',
          'changeAvatar',
          'gameSettingsButton',
          'gameSettingsBox',
        ],
      )
  );

  runApp(
      OKToast(
        child: MaterialApp(
          title: "Flutter Bird",
          navigatorKey: locator<NavigationService>().navigatorKey,
          theme: ThemeData(
            // Define the default brightness and colors.
            brightness: Brightness.dark,
            primaryColor: Colors.lightBlue,
            // Define the default font family.
            fontFamily: 'visitor',
          ),
          initialRoute: '/',
          routes: {
            routes.HomeRoute: (context) => gameWidget,
          },
          scrollBehavior: MaterialScrollBehavior().copyWith( dragDevices: {PointerDeviceKind.mouse}, ),
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
                builder: (context) {
                  return gameWidget;
                }
            );
          },
        ),
      )
  );
}

Widget _scoreScreenBuilder(BuildContext buildContext, FlutterBird game) {
  return ScoreScreen(key: UniqueKey(), game: game);
}

Widget _profileBoxBuilder(BuildContext buildContext, FlutterBird game) {
  return ProfileBox(key: UniqueKey(), game: game);
}

Widget _profileOverviewBuilder(BuildContext buildContext, FlutterBird game) {
  return ProfileOverview(key: UniqueKey(), game: game);
}

Widget _loginScreenBuilder(BuildContext buildContext, FlutterBird game) {
  return LoginScreen(key: UniqueKey(), game: game);
}

Widget _changeAvatarBoxBuilder(BuildContext buildContext, FlutterBird game) {
  return ChangeAvatarBox(key: UniqueKey(), game: game);
}

Widget _gameSettingsButtonBuilder(BuildContext buildContext, FlutterBird game) {
  return GameSettingsButton(key: UniqueKey(), game: game);
}

Widget _gameSettingsBoxBuilder(BuildContext buildContext, FlutterBird game) {
  return GameSettingsBox(key: UniqueKey(), game: game);
}
