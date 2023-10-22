import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/locator.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/game_settings.dart';
import 'package:flutter_bird/services/navigation_service.dart';
import 'package:flutter_bird/services/rest/auth_service_setting.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/user_score.dart';
import 'package:flutter_bird/util/box_window_painter.dart';
import 'package:flutter_bird/util/render_avatar.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/constants/route_paths.dart' as routes;
import 'package:flutter_bird/views/user_interface/are_you_sure_box/are_you_sure_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/change_avatar_box/change_avatar_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/login_screen/login_screen_change_notifier.dart';
import 'package:themed/themed.dart';

import 'game_settings_change_notifier.dart';


class GameSettingsBox extends StatefulWidget {

  final FlutterBird game;

  const GameSettingsBox({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  GameSettingsBoxState createState() => GameSettingsBoxState();
}

class GameSettingsBoxState extends State<GameSettingsBox> with TickerProviderStateMixin {

  // Used if any text fields are added to the profile.
  final FocusNode _focusGameSettingsBox = FocusNode();
  late GameSettingsChangeNotifier gameSettingsChangeNotifier;

  final NavigationService _navigationService = locator<NavigationService>();

  bool showGameSettings = false;
  ScrollController _controller = ScrollController();
  bool showTopScoreScreen = true;
  bool showBottomScoreScreen = true;
  bool normalMode = true;

  late GameSettings gameSettings;

  @override
  void initState() {
    gameSettingsChangeNotifier = GameSettingsChangeNotifier();
    gameSettingsChangeNotifier.addListener(gameSettingsChangeListener);

    _focusGameSettingsBox.addListener(_onFocusChange);
    _controller.addListener(() {
      checkTopBottomScroll();
    });

    gameSettings = GameSettings();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  checkTopBottomScroll() {
    if (_controller.hasClients) {
      double distanceToBottom =
          _controller.position.maxScrollExtent -
              _controller.position.pixels;
      double distanceToTop =
          _controller.position.minScrollExtent -
              _controller.position.pixels;
      if (distanceToBottom != 0) {
        setState(() {
          showBottomScoreScreen = false;
        });
      } else {
        setState(() {
          showBottomScoreScreen = true;
        });
      }
      if (distanceToTop != 0) {
        setState(() {
          showTopScoreScreen = false;
        });
      } else {
        setState(() {
          showTopScoreScreen = true;
        });
      }
    }
  }

  goBack() {
    setState(() {
      gameSettingsChangeNotifier.setGameSettingsVisible(false);
    });
  }

  gameSettingsChangeListener() {
    if (mounted) {
      if (!showGameSettings && gameSettingsChangeNotifier.getGameSettingsVisible()) {
        showGameSettings = true;
      }
      if (showGameSettings && !gameSettingsChangeNotifier.getGameSettingsVisible()) {
        showGameSettings = false;
      }
      setState(() {});
    }
  }

  _onFocusChange() {
    widget.game.gameSettingsFocus(_focusGameSettingsBox.hasFocus);
  }

  Widget gameSettingsHeader(double headerWidth, double headerHeight, double fontSize) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Text(
                "Game settings",
                style: simpleTextStyle(fontSize)
            )
          ),
          IconButton(
              icon: const Icon(Icons.close),
              color: Colors.orangeAccent.shade200,
              onPressed: () {
                setState(() {
                  goBack();
                });
              }
          ),
        ]
    );
  }

  pressedPlayerChange(int playerType) {
    if (gameSettings.getPlayerType() != playerType) {
      gameSettings.setPlayerType(playerType);
      widget.game.changePlayer(playerType);
    }
  }

  pressedBird1Change(int birdType1) {
    if (gameSettings.getBirdType1() != birdType1) {
      gameSettings.setBirdType1(birdType1);
      widget.game.changeBird1(birdType1);
    }
  }

  pressedBird2Change(int birdType2) {
    if (gameSettings.getBirdType2() != birdType2) {
      gameSettings.setBirdType2(birdType2);
      widget.game.changeBird2(birdType2);
    }
  }

  pressedBackgroundChange(int backgroundType) {
    if (gameSettings.getBackgroundType() != backgroundType) {
      gameSettings.setBackgroundType(backgroundType);
      widget.game.changeBackground(backgroundType);
    }
  }

  Widget selectionButton(String imagePath, double imageWidth, double imageHeight, int selectionType, int category, bool selected) {
    double buttonWidth = 120;
    double buttonHeight = 120;
    double widthDiff = buttonWidth - imageWidth;
    double heightDiff = buttonHeight - imageHeight;

    return InkWell(
      onHover: (value) {
        setState(() {
        });
      },
      onTap: () {
        setState(() {
          if (category == 0) {
            pressedPlayerChange(selectionType);
          } else if (category == 1) {
            pressedBird1Change(selectionType);
          } else if (category == 2) {
            pressedBird2Change(selectionType);
          } else if (category == 3) {
            pressedBackgroundChange(selectionType);
          }
        });
      },
      child: Container(
        child: Stack(
          children: [
            Container(
              width: buttonWidth,
              height: buttonHeight,
              color: selected
                  ? Colors.green.shade600
                  : Colors.transparent,
            ),
            Row(
              children: [
                Container(
                  width: widthDiff/2,
                ),
                Column(
                    children: [
                      Container(
                          height: heightDiff/2
                      ),
                      Container(
                        width: imageWidth,
                        height: imageHeight,
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ]
                ),
              ]
            ),
          ]
        ),
      ),
    );
  }

  Widget nonSelectionButton(String imagePath, double imageWidth, double imageHeight) {
    double buttonWidth = 120;
    double buttonHeight = 120;
    double widthDiff = buttonWidth - imageWidth;
    double heightDiff = buttonHeight - imageHeight;

    return Container(
      child: Stack(
        children: [
          Container(
            width: buttonWidth,
            height: buttonHeight,
            color: Colors.transparent,
          ),
          Row(
              children: [
                Container(
                  width: widthDiff/2,
                ),
                Column(
                    children: [
                      Container(
                          height: heightDiff/2
                      ),
                      ChangeColors(
                        saturation: -1,
                        child: Container(
                          width: imageWidth,
                          height: imageHeight,
                          child: Image.asset(
                            imagePath,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ]
                ),
              ]
          ),
        ]
      ),
    );
  }

  List<String> playerImagePath = [
    'assets/images/ui/game_settings/player/1_bird.png',
    'assets/images/ui/game_settings/player/2_birds.png',
  ];

  Widget playerSelection(double gameSettingsWidth, double fontSize) {
    return Container(
      width: gameSettingsWidth,
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: new List.generate(2, (int playerType) {
          bool selected = gameSettings.getPlayerType() == playerType;
          return selectionButton(playerImagePath[playerType], 100, 100, playerType, 0, selected);
        }),
      ),
    );
  }



  List<String> flutterBirdImagePath = [
    'assets/images/ui/game_settings/bird/bird_green.png',
    'assets/images/ui/game_settings/bird/bird_yellow.png',
    'assets/images/ui/game_settings/bird/bird_red.png',
    'assets/images/ui/game_settings/bird/bird_blue.png',
  ];

  Widget birdSelection1(double gameSettingsWidth, double fontSize) {
    return Container(
      width: gameSettingsWidth,
      height: 120,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: new List.generate(flutterBirdImagePath.length, (int birdType1) {
            bool selected = gameSettings.getBirdType1() == birdType1;
            return selectionButton(flutterBirdImagePath[birdType1], 100, 71, birdType1, 1, selected);
          }),
      ),
    );
  }

  Widget birdSelection2(double gameSettingsWidth, double fontSize) {
    int playerType = gameSettings.getPlayerType();
    // If the user has selected 2 birds, we don't want to show the same bird twice.
    if (playerType == 1) {
      if (gameSettings.getBirdType1() == gameSettings.getBirdType2()) {
        if (gameSettings.getBirdType1() == 0) {
          pressedBird2Change(1);
        } else {
          pressedBird2Change(gameSettings.getBirdType1()-1);
        }
      }
    }
    return Container(
      width: gameSettingsWidth,
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: new List.generate(flutterBirdImagePath.length, (int birdType2) {
          bool selected = gameSettings.getBirdType2() == birdType2;
          if (gameSettings.getBirdType1() == birdType2) {
            return nonSelectionButton(flutterBirdImagePath[birdType2], 100, 71);
          } else {
            return selectionButton(
                flutterBirdImagePath[birdType2], 100, 71, birdType2, 2, selected);
          }
        }),
      ),
    );
  }

  List<String> backgroundImagePath = [
    'assets/images/ui/game_settings/background/day.png',
    'assets/images/ui/game_settings/background/night.png',
  ];

  Widget backgroundSelection(double gameSettingsWidth, double fontSize) {
    return Container(
      width: gameSettingsWidth,
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: new List.generate(2, (int backgroundType) {
          bool selected = gameSettings.getBackgroundType() == backgroundType;
          return selectionButton(backgroundImagePath[backgroundType], 100, 100, backgroundType, 3, selected);
        }),
      ),
    );
  }

  List<String> pipeImagePath = [
    'assets/images/ui/game_settings/pipes/green_pipe.png',
    'assets/images/ui/game_settings/pipes/red_pipe.png',
  ];

  // Widget pipeSelection(double gameSettingsWidth, double fontSize) {
  //   return Container(
  //     width: gameSettingsWidth,
  //     height: 120,
  //     child: ListView(
  //       scrollDirection: Axis.horizontal,
  //       children: new List.generate(2, (int pipeType) {
  //         bool selected = gameSettings.getPipeType() == pipeType;
  //         return selectionButton(pipeImagePath[pipeType], 61, 100, pipeType, 4, selected);
  //       }),
  //     ),
  //   );
  // }

  Widget playerSelectionRow(double gameSettingsWidth, double fontSize) {
    return Column(
      children: [
        Row(
            children: [
              SizedBox(width: 20),
              Text(
                  "Player selection",
                  style: simpleTextStyle(fontSize)
              ),
            ]
        ),
        SizedBox(height: 20),
        playerSelection(gameSettingsWidth, fontSize),
        SizedBox(height: 40),
      ],
    );
  }

  Widget flutterBird1SelectionRow(double gameSettingsWidth, double fontSize) {
    String flutterBirdText = "Flutter bird";
    if (gameSettings.getPlayerType() == 1) {
      flutterBirdText = "Flutter bird 1";
    }
    return Column(
        children: [
          Row(
              children: [
                SizedBox(width: 20),
                Text(
                    flutterBirdText,
                    style: simpleTextStyle(fontSize)
                ),
              ]
          ),
          SizedBox(height: 20),
          birdSelection1(gameSettingsWidth, fontSize),
          SizedBox(height: 40),
        ],
    );
  }

  Widget flutterBird2SelectionRow(double gameSettingsWidth, double fontSize) {
    return Column(
      children: [
        Row(
            children: [
              SizedBox(width: 20),
              Text(
                  "Flutter bird 2",
                  style: simpleTextStyle(fontSize)
              ),
            ]
        ),
        SizedBox(height: 20),
        birdSelection2(gameSettingsWidth, fontSize),
        SizedBox(height: 40),
      ],
    );
  }

  Widget backgroundSelectionRow(double gameSettingsWidth, double fontSize) {
    return Column(
      children: [
        Row(
            children: [
              SizedBox(width: 20),
              Text(
                  "Background",
                  style: simpleTextStyle(fontSize)
              ),
            ]
        ),
        SizedBox(height: 20),
        backgroundSelection(gameSettingsWidth, fontSize),
        SizedBox(height: 40),
      ],
    );
  }

  // Widget pipeSelectionRow(double gameSettingsWidth, double fontSize) {
  //   return Column(
  //     children: [
  //       Row(
  //           children: [
  //             SizedBox(width: 20),
  //             Text(
  //                 "Pipes",
  //                 style: simpleTextStyle(fontSize)
  //             ),
  //           ]
  //       ),
  //       SizedBox(height: 20),
  //       pipeSelection(gameSettingsWidth, fontSize),
  //       SizedBox(height: 40),
  //     ],
  //   );
  // }

  Widget gameSettingContent(double gameSettingsWidth, double fontSize) {

    return Column(
      children: [
        playerSelectionRow(gameSettingsWidth, fontSize),
        flutterBird1SelectionRow(gameSettingsWidth, fontSize),
        gameSettings.getPlayerType() == 1
            ? flutterBird2SelectionRow(gameSettingsWidth, fontSize) : Container(),
        backgroundSelectionRow(gameSettingsWidth, fontSize),
        // pipeSelectionRow(gameSettingsWidth, fontSize),
      ]
    );
  }

  Widget gameSettingsWindow() {
    // normal mode is for desktop, mobile mode is for mobile.
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    normalMode = true;
    double heightScale = totalHeight / 800;
    double fontSize = 20 * heightScale;
    double width = 800;
    double height = (totalHeight / 10) * 9;
    // When the width is smaller than this we assume it's mobile.
    // If it's a mobile but it's landscaped, we also use normal mode.
    if (totalWidth <= 800 || totalHeight > totalWidth) {
      width = totalWidth - 50;
      height = totalHeight - 250;
      normalMode = false;
      double newHeightScaleFont = width / 800;
      fontSize = 20 * newHeightScaleFont;
    }
    double headerHeight = 40;

    return Container(
      width: width,
      height: height,
      child: CustomPaint(
        painter: BoxWindowPainter(showTop: showTopScoreScreen, showBottom: showBottomScoreScreen),
        child: NotificationListener(
            child: SingleChildScrollView(
                controller: _controller,
                child: Container(
                  child: Column(
                      children:
                      [
                        gameSettingsHeader(width-80, headerHeight, fontSize),
                        SizedBox(height: 20),
                        gameSettingContent(width-80, fontSize),
                      ]
                  ),
                )
            ),
            onNotification: (t) {
              checkTopBottomScroll();
              return true;
            }
        ),
      ),
    );
  }

  Widget gameSettingsBoxScreen(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.7),
        child: Center(
            child: TapRegion(
                onTapOutside: (tap) {
                  goBack();
                },
                child: gameSettingsWindow()
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: showGameSettings ? gameSettingsBoxScreen(context) : Container(),
    );
  }

}
