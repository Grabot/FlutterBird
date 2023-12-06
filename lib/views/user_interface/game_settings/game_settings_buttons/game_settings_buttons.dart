import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/services/game_settings.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/views/user_interface/game_settings/game_settings_box/game_settings_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/profile/profile_box/profile_change_notifier.dart';


class GameSettingsButtons extends StatefulWidget {

  final FlutterBird game;

  const GameSettingsButtons({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  GameSettingsButtonSState createState() => GameSettingsButtonSState();
}

class GameSettingsButtonSState extends State<GameSettingsButtons> {

  bool normalMode = true;
  int gameSettingsState = 0;
  int soundState = 0;
  int visibilityState = 0;

  bool showGameButtons = true;

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

  Widget visibleButton(double profileButtonSize) {
    return SizedBox(
      child: Row(
          children: [
            SizedBox(width: 5),
            Tooltip(
              message: "Show/Hide buttons",
              child: InkWell(
                onHover: (value) {
                  setState(() {
                    visibilityState = value ? 1 : 0;
                  });
                },
                onTap: () {
                  setState(() {
                    visibilityState = showGameButtons ? 2 : 0;
                    showGameButtons = !showGameButtons;
                    ProfileChangeNotifier().setProfileOverviewVisible(showGameButtons);
                  });
                },
                child: Stack(
                  children: [
                    SizedBox(
                      width: profileButtonSize,
                      height: profileButtonSize,
                      child: ClipOval(
                          child: Material(
                            color: overviewColour(visibilityState, Colors.blue, Colors.blueAccent, Colors.blue.shade800),
                          )
                      ),
                    ),
                    showGameButtons ? Image.asset(
                      "assets/images/ui/visible_on.png",
                      width: profileButtonSize,
                      height: profileButtonSize,
                    ) : Image.asset(
                      "assets/images/ui/visible_off.png",
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
                    soundState = gameSettings.getSound() ? 2 : 0;
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
                    // ugly fix to set the button back.
                    Future.delayed(Duration(milliseconds: 500), () {
                      setState(() {
                        gameSettingsState = 0;
                      });
                    });
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
        Container(
          height: 20,
        ),
        Container(
          width: buttonWidth+20,
          height: buttonHeight,
          child: visibleButton(buttonWidth),
        ),
      ]
    );
  }

  Widget gameSettingsButtonMobile(double buttonWidth, double buttonHeight, double profileHeight, double statusBarPadding, double fontSize) {
    return Column(
        children: [
          Container(
            height: statusBarPadding
          ),
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
          Container(
            height: 10,
          ),
          Container(
            width: buttonWidth+20,
            height: buttonHeight,
            child: visibleButton(buttonWidth),
          ),
        ]
    );
  }

  Widget hiddenButtonsMobile(double buttonWidth, double buttonHeight, double statusBarPadding) {
    return Container(
      width: buttonWidth + 20,
      child: Column(
        children: [
          Container(
              height: statusBarPadding
          ),
          Container(
              height: 10
          ),
          Container(
            width: buttonWidth+20,
            height: buttonHeight,
            child: visibleButton(buttonWidth),
          ),
        ]
      ),
    );
  }

  Widget hiddenButtonsNormal(double buttonWidth, double buttonHeight, double statusBarPadding) {
    return Container(
      width: buttonWidth + 20,
      child: Column(
          children: [
            Container(
                height: 20
            ),
            Container(
              width: buttonWidth+20,
              height: buttonHeight,
              child: visibleButton(buttonWidth),
            ),
          ]
      ),
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
    double extraPadding = 60;
    if (totalWidth <= 800 || totalHeight > totalWidth) {
      normalMode = false;
      profileOverviewHeight = 50;
      buttonHeight = 30;
      buttonWidth = 30;
      extraPadding = 30;
    }
    double statusBarPadding = MediaQuery.of(context).viewPadding.top;
    double combinedHeight = profileOverviewHeight + (3 * buttonHeight) + statusBarPadding;
    return Align(
      alignment: FractionalOffset.topRight,
      child: SingleChildScrollView(
        child: showGameButtons ? Container(
            width: buttonWidth + 20,
            height: combinedHeight + extraPadding,
            child: normalMode
                ? gameSettingsButtonNormal(buttonWidth, buttonHeight, profileOverviewHeight, fontSize)
                : gameSettingsButtonMobile(buttonWidth, buttonHeight, profileOverviewHeight, statusBarPadding, fontSize)
        ) : normalMode
            ? hiddenButtonsNormal(buttonWidth, buttonHeight, statusBarPadding)
            : hiddenButtonsMobile(buttonWidth, buttonHeight, statusBarPadding),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return gameSettingsWidget();
  }
}
