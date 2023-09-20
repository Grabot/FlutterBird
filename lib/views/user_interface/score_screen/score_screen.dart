import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';

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
  final FocusNode _focusScoreScreen = FocusNode();

  @override
  void initState() {
    _focusScoreScreen.addListener(_onFocusChange);
    scoreScreenChangeNotifier = ScoreScreenChangeNotifier();
    scoreScreenChangeNotifier.addListener(chatWindowChangeListener);
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

  Widget scoreScreenWidget(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      color: Colors.red,
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
