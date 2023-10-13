import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/user_score.dart';
import 'package:flutter_bird/util/box_window_painter.dart';
import 'package:flutter_bird/views/leader_board/Rank.dart';
import 'package:flutter_bird/views/leader_board/leader_board_change_notifier.dart';


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
  final FocusNode _focusLeaderBoard = FocusNode();

  ScrollController _controller = ScrollController();
  bool showTopLeaderBoard = true;
  bool showBottomLeaderBoard = true;

  @override
  void initState() {
    _focusLeaderBoard.addListener(_onFocusChange);
    leaderBoardChangeNotifier = LeaderBoardChangeNotifier();
    leaderBoardChangeNotifier.addListener(chatWindowChangeListener);
    settings = Settings();
    userScore = UserScore();

    _controller.addListener(() {
      checkTopBottomScroll();
    });
    super.initState();
  }

  chatWindowChangeListener() {
    if (mounted) {
      if (!showLeaderBoard && leaderBoardChangeNotifier.getLeaderBoardVisible()) {
        showLeaderBoard = true;
      }
      if (showLeaderBoard && !leaderBoardChangeNotifier.getLeaderBoardVisible()) {
        showLeaderBoard = false;
      }
      checkTopBottomScroll();
      setState(() {});
    }
  }

  void _onFocusChange() {
    widget.game.leaderBoardFocus(_focusLeaderBoard.hasFocus);
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

  int selectedTimeRanking = 0;
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
              color: selectedTimeRanking == 0 ? Colors.blue[200] : Colors.transparent,
              child: Text("Day", style: TextStyle(fontSize: fontSize)),
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
              color: selectedTimeRanking == 1 ? Colors.blue[200] : Colors.transparent,
              child: Text("Week", style: TextStyle(fontSize: fontSize)),
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
              color: selectedTimeRanking == 2 ? Colors.blue[200] : Colors.transparent,
              child: Text("Month", style: TextStyle(fontSize: fontSize)),
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
              color: selectedTimeRanking == 3 ? Colors.blue[200] : Colors.transparent,
              child: Text("Year", style: TextStyle(fontSize: fontSize)),
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
              color: selectedTimeRanking == 4 ? Colors.blue[200] : Colors.transparent,
              child: Text("All Time", style: TextStyle(fontSize: fontSize)),
            ),
          ),
        ],
      ),
    );
  }

  Widget leaderBoardHeaderRow(double leaderBoardWidth, double headerRowHeight, double fontSize) {
    double totalHeaderWidth = leaderBoardWidth - 20;
    double rankRowWidth = totalHeaderWidth/6;
    double nameRowWidth = (totalHeaderWidth/3)*2;
    double scoreRowWidth = totalHeaderWidth/6;
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
            color: Colors.red[200],
            child: Text("Rank", style: TextStyle(fontSize: fontSize)),
          ),
          Container(
            alignment: Alignment.center,
            width: nameRowWidth,
            height: headerRowHeight-10,
            color: Colors.red[200],
            child: Text("Name", style: TextStyle(fontSize: fontSize)),
          ),
          Container(
            alignment: Alignment.center,
            width: scoreRowWidth,
            height: headerRowHeight-10,
            color: Colors.red[200],
            child: Text("Score", style: TextStyle(fontSize: fontSize)),
          ),
        ],
      ),
    );
  }

  Widget leaderBoardTableRow(double leaderBoardWidth, Rank userRank, int index, double fontSize) {
    double totalHeaderWidth = leaderBoardWidth - 20;
    double rankRowWidth = totalHeaderWidth/6;
    double nameRowWidth = (totalHeaderWidth/3)*2;
    double scoreRowWidth = totalHeaderWidth/6;
    return Container(
      height: 100,
      color: Colors.black12,
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            width: rankRowWidth,
            height: 40,
            child: Text(
                "${index + 1}",
                style: TextStyle(fontSize: fontSize)),
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
                    style: TextStyle(fontSize: fontSize)),
                )
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: scoreRowWidth,
            height: 40,
            child: Text(
                "${userRank.getScore()}",
                style: TextStyle(fontSize: fontSize)
            ),
          ),
        ],
      ),
    );
  }

  Widget leaderBoardTable(double leaderBoardWidth, double leaderBoardHeight, double fontSize) {
    List temp = settings.rankingsOnePlayerAll;
    if (selectedTimeRanking == 0) {
      temp = settings.rankingsOnePlayerDay;
    } else if (selectedTimeRanking == 1) {
      temp = settings.rankingsOnePlayerWeek;
    } else if (selectedTimeRanking == 2) {
      temp = settings.rankingsOnePlayerMonth;
    } else if (selectedTimeRanking == 3) {
      temp = settings.rankingsOnePlayerYear;
    }
    // Only show the top 10 users, even if you have more to show
    int itemCount = 10;
    if (temp.length < 10) {
      itemCount = temp.length;
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
                return leaderBoardTableRow(leaderBoardWidth, temp[index], index, fontSize);
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

  Widget leaderContent(double leaderBoardWidth, double fontSize) {
    double leaderBoardHeight = (leaderBoardWidth/4) * 3;
    return Container(
      width: leaderBoardWidth,
      height: leaderBoardHeight,
      child: CustomPaint(
          painter: BoxWindowPainter(showTop: true, showBottom: showBottomLeaderBoard),
          child: leaderBoardContent(leaderBoardWidth, leaderBoardHeight, fontSize)
      ),
    );
  }

  nextScreen() {
    setState(() {
      leaderBoardChangeNotifier.setLeaderBoardVisible(false);
      widget.game.startGame();
    });
  }

  Widget leaderBoardScreenWidget(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double heightScale = height / 800;
    double leaderBoardWidth = 800 * heightScale;
    double fontSize = 20 * heightScale;
    if (width < leaderBoardWidth) {
      leaderBoardWidth = width-100;
      double newHeightScaleFont = width / 800;
      fontSize = 20 * newHeightScaleFont;
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          leaderBoardMessage(heightScale),
          leaderContent(leaderBoardWidth, fontSize),
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
