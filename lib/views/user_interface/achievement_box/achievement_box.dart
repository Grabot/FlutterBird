import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/user_achievements.dart';
import 'package:flutter_bird/services/user_score.dart';
import 'package:flutter_bird/util/box_window_painter.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/views/user_interface/achievement_close_up/achievement_close_up_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/login_screen/login_screen_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/models/achievement.dart';
import 'package:flutter_bird/views/user_interface/profile/profile_box/profile_change_notifier.dart';
import 'package:themed/themed.dart';

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

class AchievementBoxState extends State<AchievementBox> {

  // Used if any text fields are added to the profile.
  late AchievementBoxChangeNotifier achievementBoxChangeNotifier;

  Settings settings = Settings();
  UserAchievements userAchievements = UserAchievements();

  User? currentUser;

  bool showAchievementBox = false;

  // used to get the position and place the dropdown in the right spot
  GlobalKey cancelKey = GlobalKey();

  ScrollController _controller = ScrollController();
  bool showTopScoreScreen = true;
  bool showBottomScoreScreen = true;

  int numberOfAchievementsAchieved = 0;
  int totalOfAchievements = 0;

  @override
  void initState() {
    achievementBoxChangeNotifier = AchievementBoxChangeNotifier();
    achievementBoxChangeNotifier.addListener(achievementBoxChangeListener);

    currentUser = settings.getUser();

    totalOfAchievements = userAchievements.getAchievementsAvailable().length;
    _controller.addListener(() {
      checkTopBottomScroll();
    });
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

  achievementBoxChangeListener() {
    if (mounted) {
      if (!showAchievementBox && achievementBoxChangeNotifier.getAchievementBoxVisible()) {
        showAchievementBox = true;
        numberOfAchievementsAchieved = userAchievements.achievedAchievementList().length;
      }
      if (showAchievementBox && !achievementBoxChangeNotifier.getAchievementBoxVisible()) {
        showAchievementBox = false;
      }
      setState(() {});
    }
  }

  tappedAchievements(Achievement achievement) {
    AchievementCloseUpChangeNotifier achievementCloseUpChangeNotifier = AchievementCloseUpChangeNotifier();
    achievementCloseUpChangeNotifier.setAchievement(achievement);
    achievementCloseUpChangeNotifier.setAchievementCloseUpVisible(true);
    achievementBoxChangeNotifier.setAchievementBoxVisible(false);
  }

  Widget achievementItem(Achievement achievement, double achievementWindowWidth, double achievementSize, double fontSize) {
    double marginWidth = 20;
    return GestureDetector(
      onTap: () {
        tappedAchievements(achievement);
      },
      child: SizedBox(
        width: achievementWindowWidth,
        height: achievementSize,
        child: Row(
          children: [
            ChangeColors(
              saturation: achievement.achieved ? 0 : -1,
              child: Image.asset(
                achievement.getImagePath(),
                width: achievementSize,
                height: achievementSize,
                gaplessPlayback: true,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(width: 10),
            Container(
                width: achievementWindowWidth - achievementSize - marginWidth - 10,
                child: Text.rich(
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    TextSpan(
                      text: achievement.getTooltip(),
                      style: simpleTextStyle(fontSize*0.8),
                    ),
                )
            ),
          ],
        )
      ),
    );
  }

  Widget achievementTableHeader(double achievementWindowWidth, double fontSize) {
    return Row(
      children: [
        SizedBox(width: 10),
        Container(
            width: achievementWindowWidth - 20,
            height: 50,
            child:Text.rich(
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              TextSpan(
                text: "Total achievements achieved ${numberOfAchievementsAchieved}/${totalOfAchievements}",
                style: simpleTextStyle(fontSize),
              ),
            )
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Widget achievementList(double achievementWindowWidth, double fontSize) {
    double achievementSize = 100;
    int itemCount = userAchievements.getAchievementsAvailable().length;
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      width: achievementWindowWidth,
      height: achievementSize * itemCount,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),  // scrolling done in SingleScrollView
        itemCount: itemCount,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return achievementItem(userAchievements.getAchievementsAvailable()[index], achievementWindowWidth, achievementSize, fontSize);
        },
      ),
    );
  }

  Widget logInToGetAchievements(double achievementWindowWidth, double fontSize) {
    return Column(
      children: [
        Row(
            children:
            [
              SizedBox(width: 10),
              expandedText(achievementWindowWidth-20, "Save your achievements by creating an account!", fontSize, false),
              SizedBox(width: 10),
            ]
        ),
        SizedBox(height: 10),
        Row(
            children: [
              SizedBox(width: 20),
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    achievementBoxChangeNotifier.setAchievementBoxVisible(false);
                    LoginScreenChangeNotifier().setLoginScreenVisible(true);
                  },
                  style: buttonStyle(false, Colors.blue),
                  child: Container(
                    alignment: Alignment.center,
                    width: achievementWindowWidth/4,
                    height: fontSize,
                    child: Text(
                      'Log in',
                      style: simpleTextStyle(fontSize),
                    ),
                  ),
                ),
              ),
            ]
        ),
        SizedBox(height: 40),
      ],
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
    }
    double headerHeight = 40;

    User? currentUser = settings.getUser();

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
                      currentUser == null ? logInToGetAchievements(width, fontSize) : Container(),
                      achievementTableHeader(width, fontSize),
                      achievementList(width, fontSize),
                      SizedBox(height: 20),
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
    // If you go back from this screen you should go back to the profile screen.
    // This is because you can only open the achievement screen from the profile screen.
    // So going back means you should go back to the profile screen.
    setState(() {
      achievementBoxChangeNotifier.setAchievementBoxVisible(false);
      ProfileChangeNotifier().setProfileVisible(true);
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
