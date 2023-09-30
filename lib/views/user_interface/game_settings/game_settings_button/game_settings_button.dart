import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/locator.dart';
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
  int friendOverviewState = 0;
  GlobalKey settingsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                    friendOverviewState = value ? 1 : 0;
                  });
                },
                onTap: () {
                  setState(() {
                    friendOverviewState = 2;
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
                            color: overviewColour(friendOverviewState, Colors.blue, Colors.blueAccent, Colors.blue.shade800),
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
      ]
    );
  }

  Widget gameSettingsButtonMobile(double buttonWidth, double buttonHeight, double profileHeight, double statusBarPadding, double fontSize) {
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
        ]
    );
  }

  Widget gameSettingsWidget() {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    double heightScale = totalHeight / 800;
    double fontSize = 20 * heightScale;
    double profileOverviewHeight = 100;
    double gameSettingsButtonHeight = 50;
    double gameSettingsButtonWidth = 50;
    normalMode = true;
    if (totalWidth <= 800 || totalHeight > totalWidth) {
      normalMode = false;
      profileOverviewHeight = 50;
      gameSettingsButtonHeight = 30;
      gameSettingsButtonWidth = 30;
    }
    double combinedHeight = profileOverviewHeight + gameSettingsButtonHeight;
    double statusBarPadding = MediaQuery.of(context).viewPadding.top;
    return Align(
      alignment: FractionalOffset.topRight,
      child: SingleChildScrollView(
        child: Container(
            width: gameSettingsButtonWidth + 20,
            height: combinedHeight + 20,
            child: normalMode
                ? gameSettingsButtonNormal(gameSettingsButtonWidth, gameSettingsButtonHeight, profileOverviewHeight, fontSize)
                : gameSettingsButtonMobile(gameSettingsButtonWidth, gameSettingsButtonHeight, profileOverviewHeight, statusBarPadding, fontSize)
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return gameSettingsWidget();
  }
}
