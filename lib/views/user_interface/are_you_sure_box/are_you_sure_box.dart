import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/locator.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/navigation_service.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/views/user_interface/are_you_sure_box/are_you_sure_change_notifier.dart';


class AreYouSureBox extends StatefulWidget {

  final FlutterBird game;

  const AreYouSureBox({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  AreYouSureBoxState createState() => AreYouSureBoxState();
}

class AreYouSureBoxState extends State<AreYouSureBox> {

  final FocusNode _focusAreYouSureBox = FocusNode();
  bool showAreYouSure = false;

  late AreYouSureBoxChangeNotifier areYouSureBoxChangeNotifier;

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    areYouSureBoxChangeNotifier = AreYouSureBoxChangeNotifier();
    areYouSureBoxChangeNotifier.addListener(areYouSureBoxChangeListener);

    _focusAreYouSureBox.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  areYouSureBoxChangeListener() {
    if (mounted) {
      if (!showAreYouSure && areYouSureBoxChangeNotifier.getAreYouSureBoxVisible()) {
        setState(() {
          showAreYouSure = true;
        });
      }
      if (showAreYouSure && !areYouSureBoxChangeNotifier.getAreYouSureBoxVisible()) {
        setState(() {
          showAreYouSure = false;
        });
      }
    }
  }

  void _onFocusChange() {
    widget.game.loadingBoxFocus(_focusAreYouSureBox.hasFocus);
  }

  cancelButtonAction() {
    areYouSureBoxChangeNotifier.setAreYouSureBoxVisible(false);
  }

  logoutAction() {
    Settings settings = Settings();
    logoutUser(settings, _navigationService);
  }

  Widget areYouSureLogout() {
    return TapRegion(
      onTapOutside: (tap) {
        cancelButtonAction();
      },
      child: AlertDialog(
        title: Text("Logout?"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          ElevatedButton(
            child: Text("Cancel"),
            onPressed:  () {
              cancelButtonAction();
            },
          ),
          ElevatedButton(
            child: Text("Logout"),
            onPressed:  () {
              logoutAction();
            },
          ),
        ],
      ),
    );
  }

  Widget areYouSureBox(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: areYouSureLogout()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: showAreYouSure ? areYouSureBox(context) : Container()
    );
  }
}
