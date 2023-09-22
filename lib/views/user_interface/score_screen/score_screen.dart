import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/services/settings.dart';

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

  @override
  void initState() {
    _focusScoreScreen.addListener(_onFocusChange);
    scoreScreenChangeNotifier = ScoreScreenChangeNotifier();
    scoreScreenChangeNotifier.addListener(chatWindowChangeListener);
    settings = Settings();
    super.initState();
  }

  chatWindowChangeListener() {
    if (mounted) {
      if (!showScoreScreen && scoreScreenChangeNotifier.getScoreScreenVisible()) {
        setState(() {
          showScoreScreen = true;
        });
      }
      if (showScoreScreen && !scoreScreenChangeNotifier.getScoreScreenVisible()) {
        setState(() {
          showScoreScreen = false;
        });
      }
    }
  }

  void _onFocusChange() {
    widget.game.chatBoxFocus(_focusScoreScreen.hasFocus);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget medalHeader(double medalWidth, double fontSize) {
    return Container(
      alignment: Alignment.center,
      width: medalWidth,
      height: medalWidth/6,
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

  Widget medalImage(double medalWidth, double fontSize) {
    return Container(
      alignment: Alignment.center,
      width: medalWidth,
      height: (medalWidth/6)*4,
      color: Colors.blue,
      child: Text(
          "TODO:",
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white
          )
      ),
    );
  }

  Widget scoreNowHeader(double scoreWidth, double fontSize) {
    return Container(
      alignment: Alignment.centerRight,
      width: scoreWidth,
      height: scoreWidth/6,
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

  Widget scoreNow(double scoreWidth, double fontSize) {
    return Container(
      alignment: Alignment.centerRight,
      width: scoreWidth,
      height: (scoreWidth/12)*3,
      child: Stack(
        children: [
          Text(
            "${scoreScreenChangeNotifier.getScore()}",
            style: TextStyle(
              fontSize: fontSize*3,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
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

  Widget scoreHighHeader(double scoreWidth, double fontSize) {
    return Container(
      alignment: Alignment.centerRight,
      width: scoreWidth,
      height: scoreWidth/6,
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

  Widget scoreHigh(double scoreWidth, double fontSize) {
    return Container(
      alignment: Alignment.centerRight,
      width: scoreWidth,
      height: (scoreWidth/12)*3,
      child: Stack(
        children: [
          Text(
            "${settings.getHighScore()}",
            style: TextStyle(
              fontSize: fontSize*3,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
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

  Widget scoreScreenContent(double scoreWidth, double fontSize) {
    double leftWidth = (scoreWidth/2) - 30;
    double rightWidth = (scoreWidth/2) - 30;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            medalHeader(leftWidth, fontSize),
            medalImage(leftWidth, fontSize),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            scoreNowHeader(rightWidth, fontSize),
            scoreNow(rightWidth, fontSize),
            scoreHighHeader(rightWidth, fontSize),
            scoreHigh(rightWidth, fontSize),
          ],
        )
      ],
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
      color: Colors.green,
    );
  }

  Widget scoreContent(double scoreWidth, double fontSize) {
    return Container(
      width: scoreWidth,
      height: scoreWidth/2,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          width: 4,
        ),
      ),
      child: CustomPaint(
          painter: ScoreScreenPainter(),
          child: scoreScreenContent(scoreWidth, fontSize)
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

    print("heightScale: $heightScale");

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        gameOverMessage(heightScale),
        scoreContent(scoreWidth, fontSize),
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

class ScoreScreenPainter extends CustomPainter {

  ScoreScreenPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rectBorderOuter = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrectShadow = Rect.fromLTWH(5, 5, size.width-10, size.height-10);
    final rectBorderInner = Rect.fromLTWH(7, 7, size.width-12, size.height-12);

    final borderPaintOuter = Paint()
      ..strokeWidth = 10
      ..color = Color(0xFFece4a9)
      ..style = PaintingStyle.stroke;
    final borderPaintLine = Paint()
      ..strokeWidth = 4
      ..color = Color(0xFFd3aa33)
      ..style = PaintingStyle.stroke;
    final borderPaintInner = Paint()
      ..color = Color(0xFFdcd587)
      ..style = PaintingStyle.fill;

    canvas.drawRect(rectBorderOuter, borderPaintOuter);
    canvas.drawRect(rrectShadow, borderPaintLine);
    canvas.drawRect(rectBorderInner, borderPaintInner);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
