import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/locator.dart';
import 'package:flutter_bird/services/navigation_service.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/socket_services.dart';
import 'package:flutter_bird/util/render_avatar.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/views/user_interface/profile/profile_box/profile_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/ui_util/clear_ui.dart';


class ProfileOverview extends StatefulWidget {

  final FlutterBird game;

  const ProfileOverview({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  ProfileOverviewState createState() => ProfileOverviewState();
}

class ProfileOverviewState extends State<ProfileOverview> with TickerProviderStateMixin {

  late ProfileChangeNotifier profileChangeNotifier;
  Settings settings = Settings();

  int friendOverviewState = 0;
  int messageOverviewState = 0;

  bool unansweredFriendRequests = false;
  bool unreadMessages = false;

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    super.initState();

    profileChangeNotifier = ProfileChangeNotifier();
    profileChangeNotifier.addListener(profileChangeListener);
    settings.addListener(profileChangeListener);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    ClearUI clearUI = ClearUI();
    if (clearUI.isUiElementVisible()) {
      clearUI.clearUserInterfaces();
      return true;
    } else {
      // Ask to logout?
      showAlertDialog(context);
      return false;
    }
  }

  // Only show logout dialog when user presses back button
  showAlertDialog(BuildContext context) {  // set up the buttons
    Widget cancelButton = ElevatedButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      child: Text("Logout"),
      onPressed:  () {
        Navigator.pop(context);
        logoutUser(Settings(), _navigationService);
      },
    );  // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Leave?"),
      content: Text("Do you want to logout of Age of Gold?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  profileChangeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  selectedTileListener() {
    if (mounted) {
      setState(() {});
    }
  }

  goToProfile() {
    if (!profileChangeNotifier.getProfileVisible()) {
      profileChangeNotifier.setProfileVisible(true);
    } else if (profileChangeNotifier.getProfileVisible()) {
      profileChangeNotifier.setProfileVisible(false);
    }
  }

  openFriendWindow() {
    // FriendWindowChangeNotifier().setFriendWindowVisible(true);
  }

  Color overviewColour(int state) {
    if (state == 0) {
      return Colors.orange;
    } else if (state == 1) {
      return Colors.orangeAccent;
    } else {
      return Colors.orange.shade800;
    }
  }

  Widget getAvatar(double avatarSize) {
    return Container(
      child: settings.getAvatar() != null ? avatarBox(avatarSize, avatarSize, settings.getAvatar()!)
          : Image.asset(
        "assets/images/default_avatar.png",
        width: avatarSize,
        height: avatarSize,
      )
    );
  }

  Widget profileWidget(double profileOverviewWidth, double profileOverviewHeight) {
    return Row(
      children: [
        Container(
          width: profileOverviewWidth,
          height: profileOverviewHeight,
          color: Colors.black26,
          child: GestureDetector(
            onTap: () {
              goToProfile();
            },
            child: Row(
              children: [
                getAvatar(profileOverviewHeight),
                SizedBox(width: 5),
                SizedBox(
                  width: profileOverviewWidth - profileOverviewHeight - 5,
                  child: Text.rich(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    TextSpan(
                      text: settings.getUser() != null ? settings.getUser()!.getUserName() : "Guest",
                      style: simpleTextStyle(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]
    );
  }

  showChatWindow() {
    // ChatBoxChangeNotifier().setChatBoxVisible(false);
    // ChatWindowChangeNotifier().setChatWindowVisible(true);
  }

  Widget profileOverviewNormal(double profileOverviewWidth, double profileOverviewHeight, double fontSize) {
    double profileAvatarHeight = 100;
    return Container(
      child: Column(
        children: [
          profileWidget(profileOverviewWidth, profileAvatarHeight),
        ]
      ),
    );
  }

  Widget profileOverviewMobile(double profileOverviewWidth, double profileOverviewHeight, double statusBarPadding, double fontSize) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: statusBarPadding),
          Row(
            children: [
              Column(
                children: [
                  profileWidget(profileOverviewWidth, profileOverviewHeight),
                ],
              ),
            ]
          ),
        ]
      ),
    );
  }

  bool normalMode = true;
  Widget tileBoxWidget() {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    double heightScale = totalHeight / 800;
    double fontSize = 16 * heightScale;
    double profileOverviewWidth = 350;
    // We use the total height to hide the chatbox below
    // In NormalMode the height has the 2 buttons and some padding added.
    double profileOverviewHeight = 100;
    normalMode = true;
    double statusBarPadding = MediaQuery.of(context).viewPadding.top;
    if (totalWidth <= 800 || totalHeight > totalWidth) {
      profileOverviewWidth = totalWidth/2;
      profileOverviewWidth += 5;
      profileOverviewHeight = 50;
      normalMode = false;
      double newHeightScaleFont = profileOverviewWidth / 800;
      fontSize = 16 * newHeightScaleFont;
    }
    return Align(
      alignment: FractionalOffset.topRight,
      child: SingleChildScrollView(
        child: SizedBox(
            width: profileOverviewWidth,
            height: profileOverviewHeight + statusBarPadding,
            child: normalMode
                ? profileOverviewNormal(profileOverviewWidth, profileOverviewHeight, fontSize)
                : profileOverviewMobile(profileOverviewWidth, profileOverviewHeight, statusBarPadding, fontSize)
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return tileBoxWidget();
  }
}

