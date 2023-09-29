import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/locator.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/navigation_service.dart';
import 'package:flutter_bird/services/rest/auth_service_setting.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/user_score.dart';
import 'package:flutter_bird/util/box_window_painter.dart';
import 'package:flutter_bird/util/render_avatar.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/constants/route_paths.dart' as routes;
import 'package:flutter_bird/views/user_interface/are_you_sure_box/are_you_sure_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/change_avatar_box/change_avatar_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/login_screen/login_screen_change_notifier.dart';

import 'profile_change_notifier.dart';


class ProfileBox extends StatefulWidget {

  final FlutterBird game;

  const ProfileBox({
    required Key key,
    required this.game
  }) : super(key: key);

  @override
  ProfileBoxState createState() => ProfileBoxState();
}

class ProfileBoxState extends State<ProfileBox> with TickerProviderStateMixin {

  // Used if any text fields are added to the profile.
  final FocusNode _focusProfileBox = FocusNode();
  late ProfileChangeNotifier profileChangeNotifier;

  final NavigationService _navigationService = locator<NavigationService>();

  Settings settings = Settings();
  UserScore userScore = UserScore();

  User? currentUser;

  int levelClock = 0;
  bool canChangeTiles = true;

  bool showProfile = false;

  // used to get the position and place the dropdown in the right spot
  GlobalKey settingsKey = GlobalKey();
  GlobalKey cancelKey = GlobalKey();

  bool changeUserName = false;
  final GlobalKey<FormState> userNameKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final FocusNode _focusUsernameChange = FocusNode();

  bool changePassword = false;
  final GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _focusPasswordChange = FocusNode();

  ScrollController _controller = ScrollController();
  bool showTopScoreScreen = true;
  bool showBottomScoreScreen = true;

  @override
  void initState() {
    profileChangeNotifier = ProfileChangeNotifier();
    profileChangeNotifier.addListener(profileChangeListener);

    currentUser = settings.getUser();

    _focusProfileBox.addListener(_onFocusChange);
    settings.addListener(settingsChangeListener);
    _focusUsernameChange.addListener(_onFocusUsernameChange);
    _focusPasswordChange.addListener(_onFocusPasswordChange);

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

  profileChangeListener() {
    if (mounted) {
      if (!showProfile && profileChangeNotifier.getProfileVisible()) {
        showProfile = true;
      }
      if (showProfile && !profileChangeNotifier.getProfileVisible()) {
        showProfile = false;
      }
      setState(() {});
    }
  }

  _onFocusPasswordChange() {
    widget.game.profileFocus(_focusPasswordChange.hasFocus);
  }

  _onFocusUsernameChange() {
    widget.game.profileFocus(_focusUsernameChange.hasFocus);
  }

  _onFocusChange() {
    widget.game.profileFocus(_focusProfileBox.hasFocus);
  }

  settingsChangeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget profile() {
    // normal mode is for desktop, mobile mode is for mobile.
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    bool normalMode = true;
    double heightScale = totalHeight / 800;
    double fontSize = 20 * heightScale;
    double width = 800;
    double height = (totalHeight / 10) * 9;
    // When the width is smaller than this we assume it's mobile.
    if (totalWidth <= 800 || totalHeight > totalWidth) {
      width = totalWidth - 50;
      height = totalHeight - 250;
      normalMode = false;
      double newHeightScaleFont = width / 800;
      fontSize = 20 * newHeightScaleFont;
    }
    double headerHeight = 40;

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
                      profileHeader(width-80, headerHeight, fontSize),
                      SizedBox(height: 20),
                      userInformationBox(width-80, fontSize, normalMode),
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
    setState(() {
      profileChangeNotifier.setProfileVisible(false);
    });
  }

  userNameChange() {
    if (userNameKey.currentState!.validate()) {
      AuthServiceSetting().changeUserName(userNameController.text).then((response) {
        if (response.getResult()) {
          setState(() {
            String newUsername = response.getMessage();
            if (settings.getUser() != null) {
              settings.getUser()!.setUsername(newUsername);
              settings.notify();
            }
            setState(() {
              showToastMessage("Username changed!");
              changeUserName = false;
            });
          });
        } else {
          showToastMessage(response.getMessage());
        }
      });
    }
  }

  passwordChange() {
    if (passwordKey.currentState!.validate()) {
      AuthServiceSetting().changePassword(passwordController.text).then((response) {
        if (response.getResult()) {
          setState(() {
            setState(() {
              showToastMessage("password changed!");
              changePassword = false;
            });
          });
        } else {
          showToastMessage(response.getMessage());
        }
      });
    }
  }

  Widget profileHeader(double headerWidth, double headerHeight, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.all(20),
          child: settings.getUser() == null
              ? Text(
            "No user logged in",
            style: simpleTextStyle(fontSize),
          )
            : Text(
            "Profile Page",
            style: simpleTextStyle(fontSize)
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          color: Colors.orangeAccent.shade200,
          tooltip: 'cancel',
          onPressed: () {
            setState(() {
              goBack();
            });
          }
        ),
      ]
    );
  }

  Widget userStats(double userStatsWidth, double fontSize) {
    return Column(
      children: [
        expandedText(userStatsWidth, "Best score: ", fontSize, false),
        expandedText(userStatsWidth, "${userScore.getBestScore()}", fontSize+6, true),
        SizedBox(height: 20),
        expandedText(userStatsWidth, "Number of games played: ", fontSize, false),
        expandedText(userStatsWidth, "${userScore.getTotalGames()}", fontSize+6, true),
        SizedBox(height: 20),
        expandedText(userStatsWidth, "Total pipes cleared: ", fontSize, false),
        expandedText(userStatsWidth, "${userScore.getTotalPipesCleared()}", fontSize+6, true),
        SizedBox(height: 20),
        expandedText(userStatsWidth, "Total wing flutters: ", fontSize, false),
        expandedText(userStatsWidth, "${userScore.getTotalFlutters()}", fontSize+6, true),
      ],
    );
  }

  Widget nobodyLoggedInMobile(double width, double fontSize) {
    double widthAvatar = 300;
    if (width < widthAvatar) {
      widthAvatar = width;
    }
    return Column(
        children: [
          profileAvatar(widthAvatar, fontSize),
          SizedBox(height: 20),
          userStats(width, fontSize),
          SizedBox(height: 20),
          expandedText(width, "Save your progress by logging in!", fontSize, false),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {
                LoginScreenChangeNotifier().setLoginScreenVisible(true);
              },
              style: buttonStyle(false, Colors.blue),
              child: Container(
                alignment: Alignment.center,
                width: width/2,
                height: fontSize,
                child: Text(
                  'Log in',
                  style: simpleTextStyle(fontSize),
                ),
              ),
            ),
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
          SizedBox(height: 40),
        ]
    );
  }

  Widget nobodyLoggedInNormal(double width, double fontSize) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            profileAvatar(300, fontSize),
            SizedBox(width: 20),
            userStats((width - 300 - 20), fontSize),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                  "Save your progress by logging in!",
                  textAlign: TextAlign.center,
                  style: simpleTextStyle(fontSize)
              ),
            ),
            SizedBox(width: 10),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
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
          ],
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
        SizedBox(height: 40),
      ],
    );
  }

  Widget somebodyLoggedInNormal(double width, double fontSize) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              profileAvatar(300, fontSize),
              SizedBox(width: 20),
              userStats((width - 300 - 20), fontSize),
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
        SizedBox(height: 40),
      ]
    );
  }

  Widget changeUserNameField(double avatarWidth, double fontSize) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent)
      ),
      child: Container(
        margin: EdgeInsets.all(4),
        child: Column(
          children: [
            Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Change username", style: simpleTextStyle(fontSize)),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.orangeAccent.shade200,
                      tooltip: 'cancel',
                      onPressed: () {
                        setState(() {
                          changeUserName = false;
                        });
                      }
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: userNameKey,
              child: TextFormField(
                controller: userNameController,
                focusNode: _focusUsernameChange,
                validator: (val) {
                  return val == null || val.isEmpty
                      ? "Please enter a username if you want to change it"
                      : null;
                },
                scrollPadding: EdgeInsets.only(bottom: 120),
                decoration: const InputDecoration(
                  hintText: "New username",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                userNameChange();
              },
              style: buttonStyle(false, Colors.blue),
              child: Container(
                alignment: Alignment.center,
                width: avatarWidth,
                height: 50,
                child: Text(
                  'Change username',
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget changePasswordField(double avatarWidth, double fontSize) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent)
      ),
      child: Container(
        margin: EdgeInsets.all(4),
        child: Column(
          children: [
            Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Change password", style: simpleTextStyle(fontSize)),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.orangeAccent.shade200,
                        tooltip: 'cancel',
                        onPressed: () {
                          setState(() {
                            changePassword = false;
                          });
                        }
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: passwordKey,
              child: TextFormField(
                controller: passwordController,
                focusNode: _focusPasswordChange,
                validator: (val) {
                  return val == null || val.isEmpty
                      ? "fill in new password"
                      : null;
                },
                scrollPadding: EdgeInsets.only(bottom: 120),
                decoration: const InputDecoration(
                  hintText: "New password",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                obscureText: true,
                autofillHints: [AutofillHints.newPassword],
                style: TextStyle(color: Colors.white, fontSize: fontSize),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                passwordChange();
              },
              style: buttonStyle(false, Colors.blue),
              child: Container(
                alignment: Alignment.center,
                width: avatarWidth,
                height: 50,
                child: Text(
                  'Change password',
                  style: TextStyle(color: Colors.white, fontSize: fontSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileAvatar(double avatarWidth, double fontSize) {
    User? currentUser = settings.getUser();
    String userName = "";
    if (currentUser == null) {
      userName = "Guest";
    } else {
      userName = currentUser.getUserName();
    }
    return Container(
        width: avatarWidth,
        child: Column(
            children: [
              avatarBox(avatarWidth, avatarWidth, settings.getAvatar()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text.rich(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      TextSpan(
                        text: userName,
                        style: TextStyle(color: Colors.white, fontSize: fontSize*2),
                      ),
                    ),
                  ),
                  currentUser != null ? IconButton(
                      key: settingsKey,
                      iconSize: 40.0,
                      icon: const Icon(Icons.settings),
                      color: Colors.orangeAccent.shade200,
                      tooltip: 'Settings',
                      onPressed: _showPopupMenu
                  ) : Container()
                ],
              ),
              changeUserName ? changeUserNameField(avatarWidth, fontSize) : Container(),
              changePassword ? changePasswordField(avatarWidth, fontSize) : Container(),
            ]
        )
    );
  }

  Widget somebodyLoggedInMobile(double width, double fontSize) {
    double widthAvatar = 300;
    if (width < widthAvatar) {
      widthAvatar = width;
    }
    return Column(
      children: [
        profileAvatar(widthAvatar, fontSize),
        SizedBox(height: 20),
        userStats(width, fontSize),
        SizedBox(height: 20),
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
        SizedBox(height: 40),
      ],
    );
  }

  Widget normalModeProfile(double width, double fontSize) {
    return Container(
        child: settings.getUser() != null
            ? somebodyLoggedInNormal(width, fontSize)
            : nobodyLoggedInNormal(width, fontSize)
    );
  }

  Widget mobileModeProfile(double width, double fontSize) {
    return Container(
        child: settings.getUser() != null
            ? somebodyLoggedInMobile(width, fontSize)
            : nobodyLoggedInMobile(width, fontSize)
    );
  }

  Widget userInformationBox(double width, double fontSize, bool normalMode) {
    if (normalMode) {
      return normalModeProfile(width, fontSize);
    } else {
      return mobileModeProfile(width, fontSize);
    }
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
                child: profile()
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: showProfile ? profileBoxScreen(context) : Container(),
    );
  }

  showChangeUsername() {
    setState(() {
      changeUserName = true;
      changePassword = false;
    });
  }

  showChangePassword() {
    setState(() {
      changePassword = true;
      changeUserName = false;
    });
  }

  showChangeAvatar() {
    setState(() {
      if (settings.getAvatar() == null) {
        rootBundle.load('assets/images/default_avatar.png').then((data) {
          ChangeAvatarChangeNotifier().setAvatar(data.buffer.asUint8List());
          ChangeAvatarChangeNotifier().setChangeAvatarVisible(true);
        });
      } else {
        ChangeAvatarChangeNotifier().setAvatar(settings.getAvatar()!);
        ChangeAvatarChangeNotifier().setChangeAvatarVisible(true);
      }
      changePassword = false;
      changeUserName = false;
    });
  }

  Offset? _tapPosition;

  void _showPopupMenu() {
    _storePosition();
    _showChatDetailPopupMenu();
  }

  void _showChatDetailPopupMenu() {
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
        context: context,
        items: [SettingPopup(key: UniqueKey())],
        position: RelativeRect.fromRect(
            _tapPosition! & const Size(40, 40), Offset.zero & overlay.size))
        .then((int? delta) {
      if (delta == 0) {
        // change avatar
        showChangeAvatar();
      } else if (delta == 1) {
        // change username
        showChangeUsername();
      } else if (delta == 2) {
        // change password
        showChangePassword();
      } else if (delta == 3) {
        // logout user
        AreYouSureBoxChangeNotifier().setAreYouSureBoxVisible(true);
      }
      return;
    });
  }

  void _storePosition() {
    RenderBox box = settingsKey.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    position = position + const Offset(0, 50);
    _tapPosition = position;
  }
}

class SettingPopup extends PopupMenuEntry<int> {

  SettingPopup({required Key key}) : super(key: key);

  @override
  bool represents(int? n) => n == 1 || n == -1;

  @override
  SettingPopupState createState() => SettingPopupState();

  @override
  double get height => 1;
}

class SettingPopupState extends State<SettingPopup> {
  @override
  Widget build(BuildContext context) {
    return getPopupItems(context);
  }
}

void buttonChangeProfile(BuildContext context) {
  Navigator.pop<int>(context, 0);
}

void buttonChangeUsername(BuildContext context) {
  Navigator.pop<int>(context, 1);
}

void buttonChangePassword(BuildContext context) {
  Navigator.pop<int>(context, 2);
}

void buttonLogout(BuildContext context) {
  Navigator.pop<int>(context, 3);
}

Widget getPopupItems(BuildContext context) {
  return Column(
    children: [
      Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
            onPressed: () {
              buttonChangeProfile(context);
            },
            child: Row(
              children:const [
                Text(
                  'Change avatar',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )
              ] ,
            )
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
            onPressed: () {
              buttonChangeUsername(context);
            },
            child: Row(
              children: const [
                Text(
                  "Change username",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ]
            )
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
            onPressed: () {
              buttonChangePassword(context);
            },
            child: Row(
              children: const [
                Text(
                  "Change password",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ]
          )
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        child: TextButton(
            onPressed: () {
              buttonLogout(context);
            },
            child: Row(
              children: const [
                Text(
                  "Logout",
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )
              ],
            )
        ),
      ),
    ]
  );
}
