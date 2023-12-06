import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/user_score.dart';
import 'package:flutter_bird/util/box_window_painter.dart';
import 'package:flutter_bird/views/user_interface/models/rank.dart';
import 'package:flutter_bird/views/user_interface/leader_board/leader_board_change_notifier.dart';
import 'package:intl/intl.dart';


class LeaderBoard extends StatefulWidget {

  final FlutterBird game;

  const LeaderBoard({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  LeaderBoardState createState() => LeaderBoardState();
}

class LeaderBoardState extends State<LeaderBoard> {

  bool showLeaderBoard = false;

  late LeaderBoardChangeNotifier leaderBoardChangeNotifier;
  late Settings settings;
  late UserScore userScore;

  AutoSizeGroup sizeGroupTimeRanking = AutoSizeGroup();
  AutoSizeGroup sizeGroupHeaderRow = AutoSizeGroup();

  ScrollController _controller = ScrollController();
  bool showTopLeaderBoard = true;
  bool showBottomLeaderBoard = true;

  int selectedTimeRanking = 4;
  bool twoPlayer = false;

  @override
  void initState() {
    // _focusLeaderBoard.addListener(_onFocusChange);
    leaderBoardChangeNotifier = LeaderBoardChangeNotifier();
    leaderBoardChangeNotifier.addListener(leaderboardBoxChangeListener);
    settings = Settings();
    settings.addListener(settingsChangeListener);
    userScore = UserScore();

    _controller.addListener(() {
      checkTopBottomScroll();
    });
    super.initState();
  }

  settingsChangeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  leaderboardBoxChangeListener() {
    if (mounted) {
      if (!showLeaderBoard && leaderBoardChangeNotifier.getLeaderBoardVisible()) {
        selectedTimeRanking = leaderBoardChangeNotifier.getRankingSelection();
        twoPlayer = leaderBoardChangeNotifier.isTwoPlayer();
        showLeaderBoard = true;
      }
      if (showLeaderBoard && !leaderBoardChangeNotifier.getLeaderBoardVisible()) {
        showLeaderBoard = false;
      }
      checkTopBottomScroll();
      setState(() {});
    }
  }

  // void _onFocusChange() {
  //   widget.game.leaderBoardFocus(_focusLeaderBoard.hasFocus);
  // }

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
          showBottomLeaderBoard = false;
        });
      } else {
        setState(() {
          showBottomLeaderBoard = true;
        });
      }
      if (distanceToTop != 0) {
        setState(() {
          showTopLeaderBoard = false;
        });
      } else {
        setState(() {
          showTopLeaderBoard = true;
        });
      }
    }
  }


  Widget leaderBoardMessage(double heighScale) {
    double leaderBoardMessageWidth = 222 * heighScale * 1.5;
    double gameOverMessageHeight = 42 * heighScale * 1.5;
    return Container(
        width: leaderBoardMessageWidth,
        height: gameOverMessageHeight,
        child: Image.asset(
          "assets/images/leaderboard_image.png",
          width: leaderBoardMessageWidth,
          height: gameOverMessageHeight,
          gaplessPlayback: true,
          fit: BoxFit.fill,
        )
    );
  }

  retrieveLeaderBoard(bool onePlayer) {
    if (onePlayer) {
      settings.getLeaderBoardsOnePlayer();
    } else {
      settings.getLeaderBoardsTwoPlayer();
    }
  }

  Widget leaderBoardTimeRanking(double leaderBoardWidth, double timeRankingHeight, double fontSize) {
    double totalHeaderWidth = leaderBoardWidth - 20;
    double dayRowWidth = totalHeaderWidth/5;
    double weekRowWidth = totalHeaderWidth/5;
    double monthRowWidth = totalHeaderWidth/5;
    double yearRowWidth = totalHeaderWidth/5;
    double allTimeRowWidth = totalHeaderWidth/5;
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      width: leaderBoardWidth-20,
      height: timeRankingHeight-10,
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (selectedTimeRanking != 0) {
                setState(() {
                  selectedTimeRanking = 0;
                });
              }
            },
            child: Container(
                alignment: Alignment.center,
                width: dayRowWidth,
                height: timeRankingHeight-10,
                color: selectedTimeRanking == 0 ? Colors.green[200] : Colors.transparent,
                child: AutoSizeText(
                  "Day",
                  style: TextStyle(
                    color: Color(0xFFcba830),
                    fontSize: 50,
                  ),
                  group: sizeGroupTimeRanking,
                  maxLines: 1,
                )
            ),
          ),
          InkWell(
            onTap: () {
              if (selectedTimeRanking != 1) {
                setState(() {
                  selectedTimeRanking = 1;
                });
              }
            },
            child: Container(
                alignment: Alignment.center,
                width: weekRowWidth,
                height: timeRankingHeight-10,
                color: selectedTimeRanking == 1 ? Colors.green[200] : Colors.transparent,
                child: AutoSizeText(
                  "Week",
                  style: TextStyle(
                    color: Color(0xFFcba830),
                    fontSize: 50,
                  ),
                  group: sizeGroupTimeRanking,
                  maxLines: 1,
                )
            ),
          ),
          InkWell(
            onTap: () {
              if (selectedTimeRanking != 2) {
                setState(() {
                  selectedTimeRanking = 2;
                });
              }
            },
            child: Container(
                alignment: Alignment.center,
                width: monthRowWidth,
                height: timeRankingHeight-10,
                color: selectedTimeRanking == 2 ? Colors.green[200] : Colors.transparent,
                child: AutoSizeText(
                  "Month",
                  style: TextStyle(
                    color: Color(0xFFcba830),
                    fontSize: 50,
                  ),
                  group: sizeGroupTimeRanking,
                  maxLines: 1,
                )
            ),
          ),
          InkWell(
            onTap: () {
              if (selectedTimeRanking != 3) {
                setState(() {
                  selectedTimeRanking = 3;
                });
              }
            },
            child: Container(
                alignment: Alignment.center,
                width: yearRowWidth,
                height: timeRankingHeight-10,
                color: selectedTimeRanking == 3 ? Colors.green[200] : Colors.transparent,
                child: AutoSizeText(
                  "Year",
                  style: TextStyle(
                    color: Color(0xFFcba830),
                    fontSize: 50,
                  ),
                  group: sizeGroupTimeRanking,
                  maxLines: 1,
                )
            ),
          ),
          InkWell(
            onTap: () {
              if (selectedTimeRanking != 4) {
                setState(() {
                  selectedTimeRanking = 4;
                });
              }
            },
            child: Container(
                alignment: Alignment.center,
                width: allTimeRowWidth,
                height: timeRankingHeight-10,
                color: selectedTimeRanking == 4 ? Colors.green[200] : Colors.transparent,
                child: AutoSizeText(
                  "All Time",
                  style: TextStyle(
                    color: Color(0xFFcba830),
                    fontSize: 50,
                  ),
                  group: sizeGroupTimeRanking,
                  maxLines: 1,
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget leaderBoardHeaderRow(double leaderBoardWidth, double headerRowHeight, double fontSize) {
    double totalHeaderWidth = leaderBoardWidth - 20;
    double rankRowWidth = totalHeaderWidth/6;
    double nameRowWidth = (totalHeaderWidth/6)*2;
    double scoreRowWidth = totalHeaderWidth/6;
    double achievedAtWidth = totalHeaderWidth/3;
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      width: leaderBoardWidth-20,
      height: headerRowHeight-10,
      child: Row(
        children: [
          Container(
              alignment: Alignment.center,
              width: rankRowWidth,
              height: headerRowHeight-10,
              color: Colors.black.withOpacity(0.05),
              child: AutoSizeText(
                "Rank",
                style: TextStyle(
                  color: Color(0xFFcba830),
                  fontSize: 50,
                ),
                group: sizeGroupHeaderRow,
                maxLines: 1,
              )
          ),
          Container(
              alignment: Alignment.center,
              width: nameRowWidth,
              height: headerRowHeight-10,
              color: Colors.black.withOpacity(0.05),
              child: AutoSizeText(
                "Name",
                style: TextStyle(
                  color: Color(0xFFcba830),
                  fontSize: 50,
                ),
                group: sizeGroupHeaderRow,
                maxLines: 1,
              )
          ),
          Container(
              alignment: Alignment.center,
              width: scoreRowWidth,
              height: headerRowHeight-10,
              color: Colors.black.withOpacity(0.05),
              child: AutoSizeText(
                "Score",
                style: TextStyle(
                  color: Color(0xFFcba830),
                  fontSize: 50,
                ),
                group: sizeGroupHeaderRow,
                maxLines: 1,
              )
          ),
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(right: leaderBoardWidth/20, left: leaderBoardWidth/20),
              width: achievedAtWidth,
              height: headerRowHeight-10,
              color: Colors.black.withOpacity(0.05),
              child: AutoSizeText(
                "Achieved at",
                style: TextStyle(
                  color: Color(0xFFcba830),
                  fontSize: 50,
                ),
                group: sizeGroupHeaderRow,
                maxLines: 1,
              )
          ),
        ],
      ),
    );
  }

  Widget leaderBoardTableRow(double leaderBoardWidth, Rank userRank, int index, double fontSize) {
    double totalHeaderWidth = leaderBoardWidth - 20;
    double rankRowWidth = totalHeaderWidth/6;
    double nameRowWidth = (totalHeaderWidth/6)*2;
    double scoreRowWidth = totalHeaderWidth/6;
    double achievedAtWidth = (totalHeaderWidth/3);
    return Container(
      height: 100,
      color: userRank.getMe() ? Colors.green.withOpacity(0.3) : Colors.black26,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: rankRowWidth,
            height: 30,
            child: AutoSizeText(
              "${index + 1}",
              style: userRank.getMe()
                  ? TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              )
                  : TextStyle(fontSize: 50),
              maxLines: 1,
            )
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              width: nameRowWidth,
              child: Text.rich(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                TextSpan(
                  text: userRank.getUserName(),
                    style: userRank.getMe()
                        ? TextStyle(
                      fontSize: fontSize*1.4,
                      fontWeight: FontWeight.bold,
                    )
                        : TextStyle(fontSize: fontSize*1.4),
                )
                )
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: scoreRowWidth,
            height: 30,
            child: AutoSizeText(
              "${userRank.getScore()}",
              style: userRank.getMe()
                  ? TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              )
                  : TextStyle(fontSize: 50),
              maxLines: 1,
            )
          ),
          Container(
            alignment: Alignment.center,
            width: achievedAtWidth,
            height: 30,
            child: AutoSizeText(
              DateFormat('kk:mm - yyyy-MM-dd').format(userRank.getTimestamp()),
              style: userRank.getMe()
                  ? TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              )
                  : TextStyle(fontSize: 50),
              maxLines: 2,
            )
            // child: Text(
            //     DateFormat('kk:mm - yyyy-MM-dd').format(userRank.getTimestamp()),
            //     style: userRank.getMe()
            //         ? TextStyle(
            //       fontSize: (fontSize/4)*3,
            //       fontWeight: FontWeight.bold,
            //     )
            //         : TextStyle(fontSize: (fontSize/4)*3)
            // ),
          ),
        ],
      ),
    );
  }

  Widget leaderBoardTable(double leaderBoardWidth, double leaderBoardHeight, double fontSize) {
    List rankingList = [];
    if (!twoPlayer) {
      rankingList = settings.rankingsOnePlayerAll;
      if (selectedTimeRanking == 0) {
        rankingList = settings.rankingsOnePlayerDay;
      } else if (selectedTimeRanking == 1) {
        rankingList = settings.rankingsOnePlayerWeek;
      } else if (selectedTimeRanking == 2) {
        rankingList = settings.rankingsOnePlayerMonth;
      } else if (selectedTimeRanking == 3) {
        rankingList = settings.rankingsOnePlayerYear;
      }
    } else {
      rankingList = settings.rankingsTwoPlayerAll;
      if (selectedTimeRanking == 0) {
        rankingList = settings.rankingsTwoPlayerDay;
      } else if (selectedTimeRanking == 1) {
        rankingList = settings.rankingsTwoPlayerWeek;
      } else if (selectedTimeRanking == 2) {
        rankingList = settings.rankingsTwoPlayerMonth;
      } else if (selectedTimeRanking == 3) {
        rankingList = settings.rankingsTwoPlayerYear;
      }
    }

    // Only show the top 10 users, even if you have more to show
    int itemCount = 10;
    if (rankingList.length < 10) {
      itemCount = rankingList.length;
    }
    return Container(
      width: leaderBoardWidth-20,
      height: leaderBoardHeight,
      child: NotificationListener(
        child: Container(
          width: leaderBoardWidth,
          height: leaderBoardHeight,
          child: ListView.builder(
              controller: _controller,
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                return leaderBoardTableRow(leaderBoardWidth, rankingList[index], index, fontSize);
              }),
        ),
        onNotification: (t) {
          checkTopBottomScroll();
          return true;
        }
      )
    );
  }

  Widget leaderBoardContent(double leaderBoardWidth, double leaderBoardHeight, double fontSize) {
    double timeRankingHeight = 70;
    double headerRowHeight = 70;
    double remainingHeight = leaderBoardHeight - timeRankingHeight - headerRowHeight;
    return Column(
      children: [
        leaderBoardTimeRanking(leaderBoardWidth, timeRankingHeight, fontSize),
        leaderBoardHeaderRow(leaderBoardWidth, headerRowHeight, fontSize),
        leaderBoardTable(leaderBoardWidth, remainingHeight, fontSize),
      ],
    );
  }

  Widget leaderContent(double leaderBoardWidth, double leaderBoardHeight, double fontSize) {
    double onePlayerTwoPlayerOptionWidth = leaderBoardWidth/10;
    return Container(
      width: leaderBoardWidth+onePlayerTwoPlayerOptionWidth,
      height: leaderBoardHeight,
      child: Row(
        children: [
          CustomPaint(
            painter: BoxWindowPainter(showTop: true, showBottom: showBottomLeaderBoard),
            child: leaderBoardContent(leaderBoardWidth, leaderBoardHeight, fontSize)
          ),
          onePlayerTwoPlayerSelectionWidget(onePlayerTwoPlayerOptionWidth)
        ]
      ),
    );
  }

  nextScreen() {
    setState(() {
      leaderBoardChangeNotifier.setLeaderBoardVisible(false);
      widget.game.startGame();
    });
  }

  Widget onePlayerTwoPlayerSelectionWidget(double onePlayerTwoPlayerOptionWidth) {
    double onePlayerTwoPlayerOptionMargin = onePlayerTwoPlayerOptionWidth/10;
    return Column(
      children: [
        CustomPaint(
          painter: BoxWindowPainter(showTop: true, showBottom: true),
          child: Container(
            width: onePlayerTwoPlayerOptionWidth,
            height: onePlayerTwoPlayerOptionWidth*2,
            child: Column(
              children: [
                SizedBox(height: 2*onePlayerTwoPlayerOptionMargin),
                InkWell(
                  onTap: () {
                    if (twoPlayer) {
                      retrieveLeaderBoard(true);
                      setState(() {
                        twoPlayer = false;
                      });
                    }
                  },
                  child: Container(
                    color: !twoPlayer ? Colors.green : Color(0xFFdcd587),
                    width: onePlayerTwoPlayerOptionWidth-(2*onePlayerTwoPlayerOptionMargin),
                    height: onePlayerTwoPlayerOptionWidth-(2*onePlayerTwoPlayerOptionMargin),
                    child: Image.asset(
                      "assets/images/ui/game_settings/player/1_bird.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (!twoPlayer) {
                      retrieveLeaderBoard(false);
                      setState(() {
                        twoPlayer = true;
                      });
                    }
                  },
                  child: Container(
                    color: twoPlayer ? Colors.green : Color(0xFFdcd587),
                    width: onePlayerTwoPlayerOptionWidth-(2*onePlayerTwoPlayerOptionMargin),
                    height: onePlayerTwoPlayerOptionWidth-(2*onePlayerTwoPlayerOptionMargin),
                    child: Image.asset(
                      "assets/images/ui/game_settings/player/2_birds.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(height: 2*onePlayerTwoPlayerOptionMargin),
              ]
            ),
          ),
        ),
      ]
    );
  }

  Widget leaderBoardScreenWidget(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double heightScale = height / 800;
    double leaderBoardWidth = 800 * heightScale;
    double leaderBoardHeight = (leaderBoardWidth/4) * 3;
    double fontSize = 18 * heightScale;
    if (width < (leaderBoardWidth + (leaderBoardWidth/10))) {
      leaderBoardWidth = width-(leaderBoardWidth/10);
      // double newHeightScaleFont = width / 800;
      // fontSize = 18 * newHeightScaleFont;
      // leaderBoardHeight = (height/10)*8;
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          leaderBoardMessage(heightScale),
          leaderContent(leaderBoardWidth, leaderBoardHeight, fontSize)
        ]
    );
  }

  Widget leaderBoardScreenOverlay(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.7),
        child: Center(
            child: TapRegion(
                onTapOutside: (tap) {
                  nextScreen();
                },
                child: leaderBoardScreenWidget(context)
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: FractionalOffset.center,
        child: showLeaderBoard ? leaderBoardScreenOverlay(context) : Container()
    );
  }
}
