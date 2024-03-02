import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bird/constants/route_paths.dart' as routes;
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/locator.dart';
import 'package:flutter_bird/services/navigation_service.dart';
import 'package:flutter_bird/services/rest/auth_service_login.dart';
import 'package:flutter_bird/util/util.dart';



class BirdAccess extends StatefulWidget {

  final FlutterBird game;

  const BirdAccess({
    super.key,
    required this.game
  });

  @override
  State<BirdAccess> createState() => _BirdAccessState();
}

class _BirdAccessState extends State<BirdAccess> {

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    super.initState();
    // String baseUrl = Uri.base.toString();
    // String path = Uri.base.path;
    String? accessToken = Uri.base.queryParameters["access_token"];
    String? refreshToken = Uri.base.queryParameters["refresh_token"];

    // Use the tokens to immediately refresh the access token
    if (accessToken != null && refreshToken != null) {
      AuthServiceLogin authService = AuthServiceLogin();
      authService.getRefresh(accessToken, refreshToken).then((loginResponse) {
        if (loginResponse.getResult()) {
          // We navigate to the home screen and it should be logged in.
          _navigationService.navigateTo(routes.HomeRoute);
        } else {
          showToastMessage("something went wrong with logging in");
          _navigationService.navigateTo(routes.HomeRoute);
        }
      });
    } else {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _navigationService.navigateTo(routes.HomeRoute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
        ),
      ),
    );
  }
}
