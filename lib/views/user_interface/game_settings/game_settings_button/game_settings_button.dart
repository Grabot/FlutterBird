import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/locator.dart';
import 'package:flutter_bird/services/navigation_service.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/socket_services.dart';
import 'package:flutter_bird/util/render_avatar.dart';
import 'package:flutter_bird/util/util.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget gameSettingsButtonNormal(double buttonWidth, double buttonHeight, double profileHeight, double fontSize) {
    return Column(
      children: [
        Container(
          height: profileHeight,
        ),
        Container(
          width: buttonWidth,
          height: buttonHeight,
          color: Colors.green
        ),
      ]
    );
  }

  Widget gameSettingsButtonMobile(double buttonWidth, double buttonHeight, double profileHeight, double statusBarPadding, double fontSize) {
    return Column(
        children: [
          Container(
            height: profileHeight,
          ),
          Container(
              width: buttonWidth,
              height: buttonHeight,
              color: Colors.green
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
    if (totalWidth <= 800 || totalHeight > totalWidth) {
      profileOverviewHeight = 50;
    }
    double combinedHeight = profileOverviewHeight + gameSettingsButtonHeight;
    double statusBarPadding = MediaQuery.of(context).viewPadding.top;
    double gameSettingsButtonWidth = 50;
    return Align(
      alignment: FractionalOffset.topRight,
      child: SingleChildScrollView(
        child: Container(
            width: gameSettingsButtonWidth,
            height: combinedHeight,
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

