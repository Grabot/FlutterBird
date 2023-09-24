import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/util/box_window_painter.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/views/user_interface/login_screen/login_screen_change_notifier.dart';

import 'score_screen_change_notifier.dart';

class ScoreScreen extends StatefulWidget {

  final FlutterBird game;

  const ScoreScreen({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  ScoreScreenState createState() => ScoreScreenState();
}

class ScoreScreenState extends State<ScoreScreen> {

  bool showScoreScreen = false;

  late ScoreScreenChangeNotifier scoreScreenChangeNotifier;
  late Settings settings;
  final FocusNode _focusScoreScreen = FocusNode();

  ScrollController _controller = ScrollController();
  bool showTopScoreScreen = true;
  bool showBottomScoreScreen = true;

  @override
  void initState() {
    _focusScoreScreen.addListener(_onFocusChange);
    scoreScreenChangeNotifier = ScoreScreenChangeNotifier();
    scoreScreenChangeNotifier.addListener(chatWindowChangeListener);
    settings = Settings();

    _controller.addListener(() {
      checkTopBottomScroll();
    });
    super.initState();
  }

  chatWindowChangeListener() {
    if (mounted) {
      if (!showScoreScreen && scoreScreenChangeNotifier.getScoreScreenVisible()) {
        showScoreScreen = true;
      }
      if (showScoreScreen && !scoreScreenChangeNotifier.getScoreScreenVisible()) {
        showScoreScreen = false;
      }
      checkTopBottomScroll();
      setState(() {});
    }
  }

  void _onFocusChange() {
    widget.game.chatBoxFocus(_focusScoreScreen.hasFocus);
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

  Widget medalHeader(double medalWidth, double medalHeight, double fontSize) {
    return Container(
      alignment: Alignment.center,
      width: medalWidth,
      height: medalHeight,
      child: Text(
        "Achievements",
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Color(0xFFcba830)
        )
      ),
    );
  }

  Widget achievementsNobodyLoggedIn(double fontSize) {
    return Text(
        "TODO:",
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white
        )
    );
  }

  Widget achievementsLoggedIn(User currentUser) {
    // TODO: Test this
    return SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Text("TODO: ${currentUser.getUserName()}")
            ],
          ),
        )
    );
  }

  Widget medalImage(double medalWidth, double medalHeight, double fontSize) {
    User? currentUser = settings.getUser();
    return Container(
      alignment: Alignment.center,
      width: medalWidth,
      height: medalHeight,
      child: currentUser == null ? achievementsNobodyLoggedIn(fontSize) : achievementsLoggedIn(currentUser),
    );
  }

  Widget scoreNowHeader(double scoreWidth, double scoreHeight, double fontSize) {
    return Container(
      alignment: Alignment.centerRight,
      width: scoreWidth,
      height: scoreHeight,
      child: Text(
        "Score",
        style: TextStyle(
          fontSize: fontSize*1.5,
          fontWeight: FontWeight.bold,
          color: Color(0xFFcba830)
        )
      ),
    );
  }

  Widget scoreNow(double scoreWidth, double scoreHeight, double fontSize) {
    return Container(
      alignment: Alignment.centerRight,
      width: scoreWidth,
      height: scoreHeight,
      child: Stack(
        children: [
          Text(
            "${scoreScreenChangeNotifier.getScore()}",
            style: TextStyle(
              fontSize: fontSize*3,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = (scoreWidth / 30)
                ..color = Colors.black,
            ),
          ),
          Text(
            "${scoreScreenChangeNotifier.getScore()}",
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize*3,
            ),
          ),
        ]
      ),
    );
  }

  Widget scoreHighHeader(double scoreWidth, double scoreHeight, double fontSize) {
    return Container(
      alignment: Alignment.centerRight,
      width: scoreWidth,
      height: scoreHeight,
      child: Text(
        "Best",
        style: TextStyle(
          fontSize: fontSize*1.5,
          fontWeight: FontWeight.bold,
          color: Color(0xFFcba830)
        )
      ),
    );
  }

  Widget scoreHigh(double scoreWidth, double scoreHeight, double fontSize) {
    return Container(
      alignment: Alignment.centerRight,
      width: scoreWidth,
      height: scoreHeight,
      child: Stack(
        children: [
          Text(
            "${settings.getHighScore()}",
            style: TextStyle(
              fontSize: fontSize*3,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = (scoreWidth / 30)
                ..color = Colors.black,
            ),
          ),
          Text(
            "${settings.getHighScore()}",
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize*3,
            ),
          ),
        ]
      ),
    );
  }

  Widget loginReminder(double width, double fontSize) {
    return Column(
      children: [
        expandedText(width, "Save your progress by logging in!", 24, false),
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(width: 20),
            Container(
              alignment: Alignment.topLeft,
              child: ElevatedButton(
                onPressed: () {
                  _controller.jumpTo(0);
                  LoginScreenChangeNotifier().setLoginScreenVisible(true);
                },
                style: buttonStyle(false, Colors.blue),
                child: Container(
                  alignment: Alignment.center,
                  width: 200,
                  height: 50,
                  child: Text(
                    'Log in',
                    style: simpleTextStyle(fontSize),
                  ),
                ),
              ),
            ),
          ]
        ),
        SizedBox(height: 10),
        kIsWeb ? Text(
            "Also try Flutterbird on Android or IOS!",
            style: simpleTextStyle(fontSize)
        ) : Text(
            "Also try Flutterbird in your browser on flutterbird.eu",
            style: simpleTextStyle(fontSize)
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget scoreScreenContent(double scoreWidth, double fontSize, double heightScale) {
    double leftWidth = (scoreWidth/2) - 30;
    double rightWidth = (scoreWidth/2) - 30;
    double totalHeight = scoreWidth/2;
    double medalHeaderHeight = leftWidth/6;
    double achievementHeight = (leftWidth/6)*4;
    User? currentUser = settings.getUser();
    return Column(
      children: [
        Container(
          height: totalHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  medalHeader(leftWidth, medalHeaderHeight, fontSize),
                  medalImage(leftWidth, achievementHeight, fontSize),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  scoreNowHeader(rightWidth, rightWidth/6, fontSize),
                  scoreNow(rightWidth, (rightWidth/12)*3, fontSize),
                  scoreHighHeader(rightWidth, rightWidth/6, fontSize),
                  scoreHigh(rightWidth, (rightWidth/12)*3, fontSize),
                ],
              )
            ],
          ),
        ),
        currentUser == null ? loginReminder(scoreWidth-60, fontSize) : Container()
      ]
    );
  }

  Widget gameOverMessage(double heighScale) {
    double gameOverMessageWidth = 192 * heighScale * 1.5;
    double gameOverMessageHeight = 42 * heighScale * 1.5;
    return Container(
      width: gameOverMessageWidth,
      height: gameOverMessageHeight,
      child: Image.asset(
        "assets/images/gameover.png",
        width: gameOverMessageWidth,
        height: gameOverMessageHeight,
        gaplessPlayback: true,
        fit: BoxFit.fill,
      )
    );
  }

  Widget userInteractionButtons() {
    return Container(
      width: 400,
      height: 100,
      // color: Colors.green,
    );
  }

  Widget scoreContent(double scoreWidth, double fontSize, double heightScale) {
    return Container(
      width: scoreWidth,
      height: scoreWidth/2,
      child: CustomPaint(
          painter: BoxWindowPainter(showTop: showTopScoreScreen, showBottom: showBottomScoreScreen),
          child: NotificationListener(
              child: SingleChildScrollView(
                  controller: _controller,
                  child: scoreScreenContent(scoreWidth, fontSize, heightScale)
              ),
              onNotification: (t) {
                checkTopBottomScroll();
                return true;
              }
          )
      ),
    );
  }

  Widget scoreScreenWidget(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double heightScale = height / 800;
    double scoreWidth = 800 * heightScale;
    double fontSize = 20 * heightScale;
    if (width < scoreWidth) {
      scoreWidth = width-100;
      double newHeightScaleFont = width / 800;
      fontSize = 20 * newHeightScaleFont;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        gameOverMessage(heightScale),
        scoreContent(scoreWidth, fontSize, heightScale),
        userInteractionButtons(),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: FractionalOffset.center,
        child: showScoreScreen ? scoreScreenWidget(context) : Container()
    );
  }
}
