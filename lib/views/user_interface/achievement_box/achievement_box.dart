import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/user_score.dart';
import 'package:flutter_bird/util/box_window_painter.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/views/user_interface/models/achievement.dart';

import 'achievement_box_change_notifier.dart';


class AchievementBox extends StatefulWidget {

  final FlutterBird game;

  const AchievementBox({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  AchievementBoxState createState() => AchievementBoxState();
}

class AchievementBoxState extends State<AchievementBox> with TickerProviderStateMixin {

  // Used if any text fields are added to the profile.
  final FocusNode _focusAchievementBox = FocusNode();
  late AchievementBoxChangeNotifier achievementBoxChangeNotifier;

  Settings settings = Settings();
  UserScore userScore = UserScore();

  User? currentUser;

  bool showAchievementBox = false;

  // used to get the position and place the dropdown in the right spot
  GlobalKey cancelKey = GlobalKey();

  ScrollController _controller = ScrollController();
  bool showTopScoreScreen = true;
  bool showBottomScoreScreen = true;

  @override
  void initState() {
    achievementBoxChangeNotifier = AchievementBoxChangeNotifier();
    achievementBoxChangeNotifier.addListener(achievementBoxChangeListener);

    currentUser = settings.getUser();

    _focusAchievementBox.addListener(_onFocusChange);

    _controller.addListener(() {
      checkTopBottomScroll();
    });
    super.initState();
  }

  // TODO: Remove this dummy data
  List<Achievement> achievementsGot = [
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
    Achievement(
        imagePath: "assets/images/achievements/bird_1.png",
        tooltip: "You got this achievement by doing something"
    ),
  ];

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

  achievementBoxChangeListener() {
    if (mounted) {
      if (!showAchievementBox && achievementBoxChangeNotifier.getAchievementBoxVisible()) {
        showAchievementBox = true;
      }
      if (showAchievementBox && !achievementBoxChangeNotifier.getAchievementBoxVisible()) {
        showAchievementBox = false;
      }
      setState(() {});
    }
  }

  _onFocusChange() {
    widget.game.achievementBoxFocus(_focusAchievementBox.hasFocus);
  }

  Widget achievementItem(Achievement achievement, double achievementWindowWidth, double fontSize) {
    return Container(
      width: achievementWindowWidth,
      height: 100,
      color: Colors.red,
      child: Text(achievement.getTooltip())
    );
  }

  Widget achievementList(double achievementWindowWidth, double fontSize) {
    return Container(
      margin: EdgeInsets.all(10),
      width: achievementWindowWidth,
      height: 2000,
      child: ListView.builder(
        itemCount: achievementsGot.length,
        itemBuilder: (context, index) {
          return achievementItem(achievementsGot[index], achievementWindowWidth, fontSize);
        },
      ),
    );
  }

  Widget achievementBox() {
    // normal mode is for desktop, mobile mode is for mobile.
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    bool normalMode = true;
    double heightScale = totalHeight / 800;
    double fontSize = 16 * heightScale;
    double width = 800;
    double height = (totalHeight / 10) * 9;
    // When the width is smaller than this we assume it's mobile.
    if (totalWidth <= 800 || totalHeight > totalWidth) {
      width = totalWidth - 50;
      height = totalHeight - 250;
      normalMode = false;
      double newHeightScaleFont = width / 800;
      fontSize = 16 * newHeightScaleFont;
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
                      achievementWindowHeader(width-80, headerHeight, fontSize),
                      SizedBox(height: 20),
                      achievementList(width, fontSize),
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

  goBack() {
    print("going back");
    setState(() {
      achievementBoxChangeNotifier.setAchievementBoxVisible(false);
    });
  }

  Widget achievementWindowHeader(double headerWidth, double headerHeight, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.all(20),
          child: Text(
            "Achievement window",
            style: simpleTextStyle(fontSize),
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

  Widget profileBoxScreen(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.7),
        child: Center(
            child: TapRegion(
                onTapOutside: (tap) {
                  goBack();
                },
                child: achievementBox()
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: showAchievementBox ? profileBoxScreen(context) : Container(),
    );
  }

}
