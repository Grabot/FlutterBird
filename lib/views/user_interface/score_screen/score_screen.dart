import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/user_achievements.dart';
import 'package:flutter_bird/services/user_score.dart';
import 'package:flutter_bird/util/box_window_painter.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/views/user_interface/models/achievement.dart';
import 'package:flutter_bird/views/user_interface/models/rank.dart';
import 'package:flutter_bird/views/user_interface/leader_board/leader_board_change_notifier.dart';
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
  late UserScore userScore;
  late UserAchievements userAchievements;

  final ScrollController _controller = ScrollController();
  bool showTopScoreScreen = true;
  bool showBottomScoreScreen = true;

  @override
  void initState() {
    scoreScreenChangeNotifier = ScoreScreenChangeNotifier();
    scoreScreenChangeNotifier.addListener(chatWindowChangeListener);
    settings = Settings();
    userScore = UserScore();
    userAchievements = UserAchievements();

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

  Widget achievementsOwnedGrid(double medalWidth, double medalHeight) {
    List earnedAchievements = userAchievements.achievedAchievementList();
    return Container(
        width: medalWidth,
        height: medalHeight,
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          physics: earnedAchievements.length <= 12
              ? const NeverScrollableScrollPhysics()  // no scrolling with less than 12 items
              : const AlwaysScrollableScrollPhysics(),
          itemCount: earnedAchievements.length,
          itemBuilder: (context, index) {
            return achievementTile(earnedAchievements[index], medalWidth/4);
          },
        ),
    );
  }

  Widget achievementsOwnedList(double medalWidth, double medalHeight) {
    List ownedAchievements = userAchievements.achievedAchievementList();
    return Container(
        width: medalWidth,
        height: medalWidth/4,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: ownedAchievements.length,
          itemBuilder: (context, index) {
            return achievementTile(ownedAchievements[index], medalWidth/4);
          },
        )
    );
  }

  Widget achievementsEarnedWidget(double medalWidth, double medalHeight) {
    List achievementsEarned = scoreScreenChangeNotifier.getAchievementEarned();
    return Container(
      width: medalWidth,
      height: medalHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: achievementsEarned.length,
        itemBuilder: (context, index) {
          return achievementTile(achievementsEarned[index], medalHeight);
        },
      )
    );
  }

  Widget achievementsList(double medalWidth, double medalHeight, double fontSize) {
    List achievementsEarned = scoreScreenChangeNotifier.getAchievementEarned();
    double achievementGridHeight = medalHeight;
    if (achievementsEarned.isEmpty) {
      // no new achievements earned, show only the achievements owned.
      return Column(
          children: [
            Container(
                height: 30,
                width: medalWidth,
                child: Text(
                    "Achievements owned",
                    style: TextStyle(
                        fontSize: (fontSize/4)*3,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFcba830)
                    )
                )
            ),
            achievementsOwnedGrid(medalWidth, achievementGridHeight - 30)
          ]
      );
    } else {
      return Column(
        children: [
          Container(
              height: 30,
              width: medalWidth,
              child: Text(
                  "New achievements!",
                  style: TextStyle(
                      fontSize: (fontSize/4)*3,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFcba830)
                  )
              )
          ),
          achievementsEarnedWidget(medalWidth, (achievementGridHeight / 2) - 30),
          Container(
              height: 30,
              width: medalWidth,
              child: Text(
                  "Achievements owned",
                  style: TextStyle(
                      fontSize: (fontSize/4)*3,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFcba830)
                  )
              )
          ),
          achievementsOwnedList(medalWidth, (achievementGridHeight / 2) - 30),
        ],
      );
    }
  }

  Widget medalImage(double medalWidth, double medalHeight, double fontSize) {
    return Container(
      alignment: Alignment.center,
      width: medalWidth,
      height: medalHeight-10, // subtract the margin for the outer line.
      child: achievementsList(medalWidth, medalHeight-10, fontSize),
    );
  }

  Widget scoreSingleBirdDoubleBirdHeader(double scoreWidth, double scoreHeight, double fontSize) {
    String birdHeader = "single bird";
    if (scoreScreenChangeNotifier.isTwoPlayer()) {
      birdHeader = "double bird";
    }
    return Container(
      margin: const EdgeInsets.only(right: 20),
      alignment: Alignment.centerRight,
      width: scoreWidth-20,
      height: scoreHeight,
      child: Text(
          birdHeader,
          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xFFcba830)
          )
      ),
    );
  }

  Widget scoreNowHeader(double scoreWidth, double scoreHeight, double fontSize) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      alignment: Alignment.centerRight,
      width: scoreWidth-20,
      height: scoreHeight,
      child: Text(
        "Score",
        style: TextStyle(
          fontSize: fontSize*1.5,
          fontWeight: FontWeight.bold,
          color: const Color(0xFFcba830)
        )
      ),
    );
  }

  Widget scoreNow(double scoreWidth, double scoreHeight, double fontSize) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      alignment: Alignment.centerRight,
      width: scoreWidth-20,
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

  Widget scoreBestHeader(double scoreWidth, double scoreHeight, double fontSize) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      alignment: Alignment.centerRight,
      width: scoreWidth-20,
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

  Widget scoreBestDoubleBird(double scoreWidth, double scoreHeight, double fontSize) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      alignment: Alignment.centerRight,
      width: scoreWidth-20,
      height: scoreHeight,
      child: Stack(
          children: [
            Text(
              "${userScore.getBestScoreDoubleBird()}",
              style: TextStyle(
                fontSize: fontSize*3,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = (scoreWidth / 30)
                  ..color = Colors.black,
              ),
            ),
            Text(
              "${userScore.getBestScoreDoubleBird()}",
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize*3,
              ),
            ),
          ]
      ),
    );
  }

  Widget scoreBestSingleBird(double scoreWidth, double scoreHeight, double fontSize) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      alignment: Alignment.centerRight,
      width: scoreWidth-20,
      height: scoreHeight,
      child: Stack(
        children: [
          Text(
            "${userScore.getBestScoreSingleBird()}",
            style: TextStyle(
              fontSize: fontSize*3,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = (scoreWidth / 30)
                ..color = Colors.black,
            ),
          ),
          Text(
            "${userScore.getBestScoreSingleBird()}",
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
        expandedText(width, "Save your progress by logging in!", fontSize, false),
        SizedBox(height: 10),
        Row(
          children: [
            SizedBox(width: 20),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  _controller.jumpTo(0);
                  LoginScreenChangeNotifier().setLoginScreenVisible(true);
                },
                style: buttonStyle(false, Colors.blue),
                child: Container(
                  alignment: Alignment.center,
                  width: width/4,
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
        SizedBox(height: 10),
        Container(
          width: width,
          child: Row(
            children: [
              Expanded(
                  child: Text.rich(
                      TextSpan(
                          text: kIsWeb
                              ? "Also try Flutterbird on Android or IOS!"
                              : "Also try Flutterbird in your browser on flutterbird.eu",
                          style: simpleTextStyle(fontSize)
                      )
                  )
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget scoreScreenContent(double scoreWidth, double fontSize, double heightScale) {
    double leftWidth = (scoreWidth/2) - 30;
    double rightWidth = (scoreWidth/2) - 30;
    double totalHeight = scoreWidth/2;
    double medalHeaderHeight = totalHeight/6;
    double achievementHeight = (totalHeight/6)*5;
    User? currentUser = settings.getUser();

    double scoreHeight = (rightWidth/12)*3;
    return Column(
      children: [
        Container(
          height: totalHeight,
          child:
          Row(
            children: <Widget>[
              Expanded(
                flex: 7, // 30%
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    medalHeader(leftWidth, medalHeaderHeight, fontSize),
                    medalImage(leftWidth, achievementHeight, fontSize),
                  ],
                ),
              ),
              Expanded(
                flex: 3, // 70%
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    scoreSingleBirdDoubleBirdHeader(rightWidth, rightWidth/12, fontSize),
                    scoreNowHeader(rightWidth, rightWidth/6, fontSize),
                    scoreNow(rightWidth, scoreHeight, fontSize),
                    scoreBestHeader(rightWidth, rightWidth/6, fontSize),
                    scoreScreenChangeNotifier.isTwoPlayer()
                        ? scoreBestDoubleBird(rightWidth, scoreHeight, fontSize)
                        : scoreBestSingleBird(rightWidth, scoreHeight, fontSize),
                  ],
                ),
              ),
            ],
          )
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

  Widget userInteractionButtons(double scoreWidth, double fontSize) {
    return Container(
      width: scoreWidth,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: TextButton(
                onPressed: () {
                  nextScreen(false);
                },
                child: Container(
                  width: scoreWidth/4,
                  height: scoreWidth/20,
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
          ),
          Container(
            child: TextButton(
                onPressed: () {
                  getLeaderBoardSettings();
                  nextScreen(true);
                },
                child: Container(
                  width: scoreWidth/4,
                  height: scoreWidth/20,
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      'Leaderboard',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: fontSize),
                    ),
                  ),
                )
            ),
          ),
          Container(
            child: TextButton(
                onPressed: () {
                  // TODO: implement the share functionality.
                },
                child: Container(
                  width: scoreWidth/4,
                  height: scoreWidth/20,
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      'Share',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: fontSize),
                    ),
                  ),
                )
            ),
          ),
        ],
      ),
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

  nextScreen(bool goToLeaderboard) {
    setState(() {
      if (goToLeaderboard) {
        scoreScreenChangeNotifier.setScoreScreenVisible(false);
        LeaderBoardChangeNotifier leaderBoardChangeNotifier = LeaderBoardChangeNotifier();
        leaderBoardChangeNotifier.setTwoPlayer(scoreScreenChangeNotifier.isTwoPlayer());
        leaderBoardChangeNotifier.setLeaderBoardVisible(true);
      } else {
        scoreScreenChangeNotifier.setScoreScreenVisible(false);
        widget.game.startGame();
      }
    });
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
        userInteractionButtons(scoreWidth, fontSize),
      ]
    );
  }

  getLeaderBoardSettings() {
    // Check if the user made the leaderboard of the week or month or even of all time.
    // If this is the case we want to automatically open on that selection.
    User? currentUser = settings.getUser();
    if (currentUser != null) {
      int currentScore = scoreScreenChangeNotifier.getScore();
      int rankingSelection = 4;
      if (!scoreScreenChangeNotifier.isTwoPlayer()) {
        rankingSelection = getRankingSelection(true, currentScore, settings);
      } else {
        rankingSelection = getRankingSelection(false, currentScore, settings);
      }
      LeaderBoardChangeNotifier().setRankingSelection(rankingSelection);
    }
  }

  tappedOutside() {
    User? currentUser = settings.getUser();
    if (currentUser != null) {
      int tenthPosDayScore = -1;
      // If there aren't 10 scores yet, we will just set it to -1
      // so the current score is always higher. The user will have made the leaderboard
      if (settings.rankingsOnePlayerDay.length >= 10) {
        tenthPosDayScore = settings.rankingsOnePlayerDay[9].getScore();
        getLeaderBoardSettings();
      }
      if (scoreScreenChangeNotifier.getScore() > tenthPosDayScore) {
        // The user is now on the leaderboard so we will show it.
        nextScreen(true);
      } else {
        nextScreen(false);
      }
    } else {
      nextScreen(false);
    }
  }

  Widget scoreScreenOverlay(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.7),
        child: Center(
            child: TapRegion(
                onTapOutside: (tap) {
                  tappedOutside();
                },
                child: scoreScreenWidget(context)
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: FractionalOffset.center,
        child: showScoreScreen ? scoreScreenOverlay(context) : Container()
    );
  }
}
