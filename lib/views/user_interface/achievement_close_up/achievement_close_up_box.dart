import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/util/box_window_painter.dart';
import 'package:flutter_bird/views/user_interface/achievement_box/achievement_box_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/achievement_close_up/achievement_close_up_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/models/achievement.dart';
import 'package:themed/themed.dart';


class AchievementCloseUpBox extends StatefulWidget {

  final FlutterBird game;

  const AchievementCloseUpBox({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  AchievementCloseUpBoxState createState() => AchievementCloseUpBoxState();
}

class AchievementCloseUpBoxState extends State<AchievementCloseUpBox> {

  bool showAchievementCloseUp = false;

  late AchievementCloseUpChangeNotifier achievementCloseUpChangeNotifier;

  final ScrollController _controller = ScrollController();
  bool showTopScoreScreen = true;
  bool showBottomScoreScreen = true;

  Achievement? closeUpAchievement;

  @override
  void initState() {
    achievementCloseUpChangeNotifier = AchievementCloseUpChangeNotifier();
    achievementCloseUpChangeNotifier.addListener(achievementCloseUpBoxChangeListener);

    _controller.addListener(() {
      checkTopBottomScroll();
    });
    super.initState();
  }

  @override
  void dispose() {
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

  achievementCloseUpBoxChangeListener() {
    if (mounted) {
      if (!showAchievementCloseUp && achievementCloseUpChangeNotifier.getAchievementCloseUpVisible()) {
        setState(() {
          closeUpAchievement = achievementCloseUpChangeNotifier.getAchievement();
          showAchievementCloseUp = true;
        });
      }
      if (showAchievementCloseUp && !achievementCloseUpChangeNotifier.getAchievementCloseUpVisible()) {
        setState(() {
          showAchievementCloseUp = false;
        });
      }
    }
  }

  goBack() {
    setState(() {
      cancelButtonAction();
    });
  }

  cancelButtonAction() {
    setState(() {
      achievementCloseUpChangeNotifier.setAchievementCloseUpVisible(false);
      AchievementBoxChangeNotifier().setAchievementBoxVisible(true);
    });
  }

  Widget achievementWindowHeader(double headerWidth, double headerHeight, double fontSize) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                "Achievement",
                style: TextStyle(
                    color: const Color(0xFFcba830),
                    fontSize: fontSize*1.4
                ),
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

  Widget achievementName(double fontSize) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Text(
        closeUpAchievement!.getAchievementName(),
        style: TextStyle(
            color: const Color(0xFFcba830),
            fontSize: fontSize*1.4
        ),
      ),
    );
  }

  achievementImage(double width) {
    return Container(
      child: ChangeColors(
        saturation: closeUpAchievement!.achieved ? 0 : -1,
        child: Image.asset(
          closeUpAchievement!.getImagePath(),
          width: width,
          height: width,
          gaplessPlayback: true,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget achievementAchieved(double fontSize) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Text(
        closeUpAchievement!.achieved ? "Achieved" : "Not achieved",
        style: TextStyle(
            color: const Color(0xFFcba830),
            fontSize: fontSize*1.2
        ),
      ),
    );
  }

  Widget achievementInformation(double fontSize) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Text(
        closeUpAchievement!.getTooltip(),
        style: TextStyle(
            color: const Color(0xFFcba830),
            fontSize: fontSize*1.2
        ),
      ),
    );
  }

  Widget achievementDetail(double width, double fontSize) {
    return Column(
      children: [
        achievementName(fontSize),
        achievementInformation(fontSize),
        achievementImage(width-80),
        achievementAchieved(fontSize),
      ],
    );
  }

  Widget achievementCloseUp(double totalWidth, double totalHeight) {
    double heightScale = totalHeight / 800;
    double fontSize = 16 * heightScale;
    double width = 800;
    double height = (totalHeight / 10) * 6;
    // When the width is smaller than this we assume it's mobile.
    if (totalWidth <= 800 || totalHeight > totalWidth) {
      width = totalWidth - 50;
    }
    double headerHeight = 40;
    return TapRegion(
      onTapOutside: (tap) {
        cancelButtonAction();
      },
      child: SizedBox(
        width:width,
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
                          const SizedBox(height: 20),
                          closeUpAchievement != null ? achievementDetail(width, fontSize) : Container()
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
      )
    );
  }

  Widget continueButton(double screenWidth, double screenHeight, double fontSize) {
    return Container(
      child: TextButton(
          onPressed: () {
            goBack();
          },
          child: Container(
            width: screenWidth/8,
            height: screenHeight/20,
            color: Colors.blue,
            child: Center(
              child: Text(
                'Ok',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ),
            ),
          )
      ),
    );
  }

  Widget achievementCloseUpBox(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    return Container(
      width: totalWidth,
      height: totalHeight,
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(),
              achievementCloseUp(totalWidth, totalHeight),
              continueButton(totalWidth, totalHeight, 16)
            ]
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: showAchievementCloseUp ? achievementCloseUpBox(context) : Container()
    );
  }
}
