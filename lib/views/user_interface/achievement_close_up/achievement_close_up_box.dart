import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/locator.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/navigation_service.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/util/box_window_painter.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/views/user_interface/achievement_box/achievement_box_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/achievement_close_up/achievement_close_up_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/are_you_sure_box/are_you_sure_change_notifier.dart';
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

  ScrollController _controller = ScrollController();
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
          print("achievement close up show");
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
              margin: EdgeInsets.all(20),
              child: Text(
                "Achievement",
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

  Widget achievementName() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text(
        closeUpAchievement!.getAchievementName(),
        style: simpleTextStyle(20),
      ),
    );
  }

  achievementImage(double width) {
    return ChangeColors(
      saturation: closeUpAchievement!.achieved ? 0 : -1,
      child: Image.asset(
        closeUpAchievement!.getImagePath(),
        width: width,
        height: width,
        gaplessPlayback: true,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget achievementAchieved() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text(
        closeUpAchievement!.achieved ? "Achieved" : "Not achieved",
        style: simpleTextStyle(16),
      ),
    );
  }

  Widget achievementInformation() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Text(
        closeUpAchievement!.getTooltip(),
        style: simpleTextStyle(16),
      ),
    );
  }

  Widget achievementDetail(double width) {
    return Column(
      children: [
        achievementName(),
        achievementInformation(),
        achievementImage(width-20),
        achievementAchieved(),
      ],
    );
  }

  Widget achievementCloseUp() {
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
    }
    double headerHeight = 40;
    return TapRegion(
      onTapOutside: (tap) {
        cancelButtonAction();
      },
      child: Container(
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
                          SizedBox(height: 20),
                          closeUpAchievement != null ? achievementDetail(width) : Container()
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

  Widget achievementCloseUpBox(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: achievementCloseUp()
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
