import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/locator.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_bird/constants/route_paths.dart' as routes;
import 'services/navigation_service.dart';
import 'services/settings.dart';
import 'views/user_interface/score_screen/score_screen.dart';

Future<void> main() async {
  setPathUrlStrategy();
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();

  // initialize the settings singleton
  Settings();
  Flame.images.loadAll(<String>[]);

  FocusNode gameFocus = FocusNode();

  final game = FlutterBird(gameFocus);

  Widget gameWidget = Scaffold(
      body: GameWidget(
        focusNode: gameFocus,
        game: game,
        overlayBuilderMap: const {
          'scoreScreen': _scoreScreenBuilder,
        },
        initialActiveOverlays: const [
          'scoreScreen',
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
            fontFamily: 'Georgia',
          ),
          initialRoute: '/',
          routes: {
            routes.HomeRoute: (context) => gameWidget,
          },
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
