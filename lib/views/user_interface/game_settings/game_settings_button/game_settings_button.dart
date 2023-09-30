import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/locator.dart';
import 'package:flutter_bird/services/game_settings.dart';
import 'package:flutter_bird/services/navigation_service.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/socket_services.dart';
import 'package:flutter_bird/util/render_avatar.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/views/user_interface/game_settings/game_settings_box/game_settings_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/profile/profile_box/profile_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/ui_util/clear_ui.dart';


class GameSettingsButton extends StatefulWidget {

  final FlutterBird game;

  const GameSettingsButton({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  GameSettingsButtonState createState() => GameSettingsButtonState();
}

class GameSettingsButtonState extends State<GameSettingsButton> with TickerProviderStateMixin {

  bool normalMode = true;
  int gameSettingsState = 0;
  int soundState = 0;

  GlobalKey settingsKey = GlobalKey();

  late GameSettings gameSettings;

  @override
  void initState() {
    super.initState();
    gameSettings = GameSettings();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget soundButton(double profileButtonSize) {
    return SizedBox(
      child: Row(
          children: [
            SizedBox(width: 5),
            Tooltip(
              message: "Sound settings",
              child: InkWell(
                onHover: (value) {
                  setState(() {
                    soundState = value ? 1 : 0;
                  });
                },
                onTap: () {
                  setState(() {
                    soundState = 2;
                    gameSettings.setSound(!gameSettings.getSound());
                  });
                },
                child: Stack(
                  children: [
                    SizedBox(
                      width: profileButtonSize,
                      height: profileButtonSize,
                      child: ClipOval(
                          child: Material(
                            color: overviewColour(soundState, Colors.blue, Colors.blueAccent, Colors.blue.shade800),
                          )
                      ),
                    ),
                    gameSettings.getSound() ? Image.asset(
                      "assets/images/ui/sound_on.png",
                      width: profileButtonSize,
                      height: profileButtonSize,
                    ) : Image.asset(
                      "assets/images/ui/sound_off.png",
                      width: profileButtonSize,
                      height: profileButtonSize,
                    ),
                  ],
                ),
              ),
            ),
          ]
      ),
    );
  }

  Widget gameSettingsButton(double profileButtonSize) {
    return SizedBox(
      child: Row(
          children: [
            SizedBox(width: 5),
            Tooltip(
              message: "Game settings",
              child: InkWell(
                onHover: (value) {
                  setState(() {
                    gameSettingsState = value ? 1 : 0;
                  });
                },
                onTap: () {
                  setState(() {
                    gameSettingsState = 2;
                  });
                  GameSettingsChangeNotifier().setGameSettingsVisible(true);
                },
                child: Stack(
                  children: [
                    SizedBox(
                      width: profileButtonSize,
                      height: profileButtonSize,
                      child: ClipOval(
                          child: Material(
                            color: overviewColour(gameSettingsState, Colors.blue, Colors.blueAccent, Colors.blue.shade800),
                          )
                      ),
                    ),
                    Image.asset(
                      "assets/images/ui/game_settings_button.png",
                      width: profileButtonSize,
                      height: profileButtonSize,
                    ),
                  ],
                ),
              ),
            ),
          ]
      ),
    );
  }

  Widget gameSettingsButtonNormal(double buttonWidth, double buttonHeight, double profileHeight, double fontSize) {
    return Column(
      children: [
        Container(
          height: profileHeight+20,
        ),
        Container(
          width: buttonWidth+20,
          height: buttonHeight,
          child: gameSettingsButton(buttonWidth),
        ),
        Container(
          height: 20,
        ),
        Container(
          width: buttonWidth+20,
          height: buttonHeight,
          child: soundButton(buttonWidth),
        ),
      ]
    );
  }

  Widget gameSettingsButtonMobile(double buttonWidth, double buttonHeight, double profileHeight, double statusBarPadding, double fontSize) {
    return Column(
        children: [
          Container(
            height: profileHeight+10,
          ),
          Container(
            width: buttonWidth+20,
            height: buttonHeight,
            child: gameSettingsButton(buttonWidth),
          ),
          Container(
            height: 10,
          ),
          Container(
            width: buttonWidth+20,
            height: buttonHeight,
            child: soundButton(buttonWidth),
          ),
        ]
    );
  }

  Widget gameSettingsWidget() {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    double heightScale = totalHeight / 800;
    double fontSize = 20 * heightScale;
    double profileOverviewHeight = 100;
    double buttonHeight = 50;
    double buttonWidth = 50;
    normalMode = true;
    double extraPadding = 40;
    if (totalWidth <= 800 || totalHeight > totalWidth) {
      normalMode = false;
      profileOverviewHeight = 50;
      buttonHeight = 30;
      buttonWidth = 30;
      extraPadding = 20;
    }
    double combinedHeight = profileOverviewHeight + buttonHeight + buttonHeight;
    double statusBarPadding = MediaQuery.of(context).viewPadding.top;
    return Align(
      alignment: FractionalOffset.topRight,
      child: SingleChildScrollView(
        child: Container(
            width: buttonWidth + 20,
            height: combinedHeight + extraPadding,
            child: normalMode
                ? gameSettingsButtonNormal(buttonWidth, buttonHeight, profileOverviewHeight, fontSize)
                : gameSettingsButtonMobile(buttonWidth, buttonHeight, profileOverviewHeight, statusBarPadding, fontSize)
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return gameSettingsWidget();
  }
}
