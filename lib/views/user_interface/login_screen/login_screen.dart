import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/locator.dart';
import 'package:flutter_bird/services/navigation_service.dart';
import 'package:flutter_bird/views/user_interface/login_screen/login_screen_change_notifier.dart';


class LoginScreen extends StatefulWidget {

  final FlutterBird game;

  const LoginScreen({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  bool showLoginScreen = true;

  late LoginScreenChangeNotifier loginScreenChangeNotifier;

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    loginScreenChangeNotifier = LoginScreenChangeNotifier();
    loginScreenChangeNotifier.addListener(loginScreenChangeListener);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  loginScreenChangeListener() {
    if (mounted) {
      if (!showLoginScreen && loginScreenChangeNotifier.getLoginScreenVisible()) {
        setState(() {
          showLoginScreen = true;
        });
      }
      if (showLoginScreen && !loginScreenChangeNotifier.getLoginScreenVisible()) {
        setState(() {
          showLoginScreen = false;
        });
      }
    }
  }

  Widget LoginOrRegisterBox(BuildContext context) {
    double width = 500;
    double height = 500;
    return Container(
      width: width,
      height: height,
      color: Colors.blue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: showLoginScreen ? LoginOrRegisterBox(context) : Container()
    );
  }
}
