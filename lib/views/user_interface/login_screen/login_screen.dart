import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bird/constants/url_base.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/locator.dart';
import 'package:flutter_bird/services/navigation_service.dart';
import 'package:flutter_bird/services/rest/auth_service_login.dart';
import 'package:flutter_bird/services/rest/models/login_request.dart';
import 'package:flutter_bird/services/rest/models/register_request.dart';
import 'package:flutter_bird/util/box_window_painter.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/views/user_interface/login_screen/login_screen_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/profile/profile_box/profile_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/profile/profile_overview/profile_overview.dart';
import 'package:flutter_bird/views/user_interface/score_screen/score_screen_change_notifier.dart';
import 'package:flutter_bird/views/user_interface/ui_util/clear_ui.dart';
import 'package:url_launcher/url_launcher.dart';


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

  bool showLoginScreen = false;

  late LoginScreenChangeNotifier loginScreenChangeNotifier;

  final NavigationService _navigationService = locator<NavigationService>();

  bool normalMode = true;
  bool isLoading = false;

  int signUpMode = 0;
  bool passwordResetSend = false;

  final formKeyLogin = GlobalKey<FormState>();
  final formKeyReset = GlobalKey<FormState>();
  final formKeyRegister = GlobalKey<FormState>();

  TextEditingController emailOrUsernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController password1Controller = new TextEditingController();
  TextEditingController password2Controller = new TextEditingController();
  TextEditingController forgotPasswordEmailController = new TextEditingController();

  FocusNode _focusEmail = FocusNode();
  FocusNode _focusPassword = FocusNode();

  ScrollController _controller = ScrollController();
  bool showTopScoreScreen = true;
  bool showBottomScoreScreen = true;

  @override
  void initState() {
    loginScreenChangeNotifier = LoginScreenChangeNotifier();
    loginScreenChangeNotifier.addListener(loginScreenChangeListener);
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

  goBack() {
    setState(() {
      LoginScreenChangeNotifier().setLoginScreenVisible(false);
      widget.game.focusGame();
    });
  }

  signInFlutterBird() {
    if (formKeyLogin.currentState!.validate() && !isLoading) {
      isLoading = true;
      // send login request
      String emailOrUserName = emailOrUsernameController.text;
      String password = password1Controller.text;
      AuthServiceLogin authServiceLogin = AuthServiceLogin();
      bool isWeb = false;
      if (kIsWeb) {
        isWeb = true;
      }
      LoginRequest loginRequest = LoginRequest(emailOrUserName, password, isWeb);
      authServiceLogin.getLogin(loginRequest).then((loginResponse) {
        if (loginResponse.getResult()) {
          ScoreScreenChangeNotifier().notify();
          goBack();
          isLoading = false;
          setState(() {});
        } else if (!loginResponse.getResult()) {
          showToastMessage(loginResponse.getMessage());
          isLoading = false;
        }
      }).onError((error, stackTrace) {
        showToastMessage(error.toString());
        isLoading = false;
      });
    }
  }


  signUpFlutterBird() {
    if (formKeyRegister.currentState!.validate() && !isLoading) {
      isLoading = true;
      String email = emailController.text;
      String userName = usernameController.text;
      String password = password2Controller.text;
      AuthServiceLogin authService = AuthServiceLogin();
      bool isWeb = false;
      if (kIsWeb) {
        isWeb = true;
      }
      RegisterRequest registerRequest = RegisterRequest(email, userName, password, isWeb);
      authService.getRegister(registerRequest).then((loginResponse) {
        if (loginResponse.getResult()) {
          ScoreScreenChangeNotifier().notify();
          goBack();
          isLoading = false;
          setState(() {});
        } else if (!loginResponse.getResult()) {
          showToastMessage(loginResponse.getMessage());
          isLoading = false;
        }
      }).onError((error, stackTrace) {
        showToastMessage(error.toString());
        isLoading = false;
      });
    }
  }

  String resetEmail = "";
  forgotPassword() {
    if (formKeyReset.currentState!.validate() && !isLoading) {
      isLoading = true;
      resetEmail = forgotPasswordEmailController.text;
      AuthServiceLogin authService = AuthServiceLogin();
      authService.getPasswordReset(resetEmail).then((passwordResetResponse) {
        if (passwordResetResponse.getResult()) {
          setState(() {
            passwordResetSend = true;
          });
          isLoading = false;
        } else if (!passwordResetResponse.getResult()) {
          showToastMessage(passwordResetResponse.getMessage());
          resetEmail = "";
          isLoading = false;
        }
      }).onError((error, stackTrace) {
        showToastMessage(error.toString());
        resetEmail = "";
        isLoading = false;
      });
    }
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
          signUpMode = 0;
          passwordResetSend = false;
        });
      }
    }
  }

  Widget justPlayGame(double width, double fontSize) {
    return Column(
      children: [
        Row(
            children: [
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                      color: Colors.white,
                      height: 36,
                    )),
              ),
              Text("or"),
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Divider(
                      color: Colors.white,
                      height: 36,
                    )),
              ),
            ]
        ),
        ElevatedButton(
          onPressed: () {
            goBack();
          },
          style: buttonStyle(false, Colors.blue),
          child: Container(
            alignment: Alignment.center,
            width: width,
            height: 50,
            child: Text(
              'Just play the game!',
              style: simpleTextStyle(fontSize),
            ),
          ),
        )
      ],
    );
  }

  Widget loginAlternatives(double loginBoxSize, double fontSize) {
    return Column(
      children: [
        Row(
            children: [
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                    child: Divider(
                      color: Colors.white,
                      height: 36,
                    )),
              ),
              signUpMode == 0 ? Text("or login with") : Container(),
              signUpMode == 1 ? Text("or register with") : Container(),
              Expanded(
                child: new Container(
                    margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                    child: Divider(
                      color: Colors.white,
                      height: 36,
                    )),
              ),
            ]
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
                children: [
                  InkWell(
                    onTap: () {
                      final Uri _url = Uri.parse(googleLogin);
                      _launchUrl(_url);
                    },
                    child: SizedBox(
                      height: loginBoxSize,
                      width: loginBoxSize,
                      child: Image.asset(
                          "assets/images/google_button.png"
                      ),
                    ),
                  ),
                  Text(
                    "Google",
                    style: TextStyle(fontSize: fontSize),
                  )
                ]
            ),
            SizedBox(width: 10),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    final Uri _url = Uri.parse(githubLogin);
                    _launchUrl(_url);
                  },
                  child: SizedBox(
                    height: loginBoxSize,
                    width: loginBoxSize,
                    child: Image.asset(
                        "assets/images/github_button.png"
                    ),
                  ),
                ),
                Text(
                  "Github",
                  style: TextStyle(fontSize: fontSize),
                )
              ],
            ),
            SizedBox(width: 10),
            Column(
                children: [
                  InkWell(
                    onTap: () {
                      final Uri _url = Uri.parse(redditLogin);
                      _launchUrl(_url);
                    },
                    child: SizedBox(
                      height: loginBoxSize,
                      width: loginBoxSize,
                      child: Image.asset(
                          "assets/images/reddit_button.png"
                      ),
                    ),
                  ),
                  Text(
                    "Reddit",
                    style: TextStyle(fontSize: fontSize),
                  )
                ]
            ),
          ],
        ),
      ],
    );
  }

  Widget resetPasswordEmailSend(double width, double fontSize) {
    return Column(
      children: [
        Text(
          "Check your email",
          style: TextStyle(color: Colors.white, fontSize: fontSize*2),
        ),
        SizedBox(height: 10),
        Column(
          children: [
            Text(
              "Please check the email address $resetEmail for instructions to reset your password. \nThis might take a few minutes",
              style: TextStyle(color: Colors.white70, fontSize: fontSize),
            ),
          ]
        ),
      ],
    );
  }

  Widget resetPassword(double width, double fontSize) {
    return Form(
      key: formKeyReset,
      child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Reset your password",
                  style: TextStyle(color: Colors.white, fontSize: fontSize*1.5),
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
                children: [
                  Text(
                    "Enter your email address and we will send you instructions to reset your password.",
                    style: TextStyle(color: Colors.white70, fontSize: fontSize),
                  ),
                ]
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                onTap: () {

                },
                validator: (val) {
                  return val == null || val.isEmpty
                      ? "Please provide an Email address"
                      : null;
                },
                onFieldSubmitted: (value) {
                  if (!isLoading) {
                    forgotPassword();
                  }
                },
                scrollPadding: const EdgeInsets.only(bottom: 130),
                controller: forgotPasswordEmailController,
                autofillHints: [AutofillHints.email],
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Roboto",
                    fontSize: fontSize,
                    color: Colors.white
                ),
                decoration:
                textFieldInputDecoration("Email adddress"),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (!isLoading) {
                            setState(() {
                              signUpMode = 0;
                            });
                          }
                        },
                        child: Text(
                          "Back to login",
                          style: TextStyle(color: Colors.blue, fontSize: fontSize),
                        )
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (!isLoading) {
                  forgotPassword();
                }
              },
              style: buttonStyle(false, Colors.blue),
              child: Container(
                alignment: Alignment.center,
                width: width,
                height: 50,
                child: Text(
                  'Continue',
                  style: simpleTextStyle(fontSize),
                ),
              ),
            )
          ]
      ),
    );
  }

  Widget register(double width, double fontSize) {
    return Form(
      key: formKeyRegister,
      child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Create Account",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize*1.5
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (!isLoading) {
                            setState(() {
                              signUpMode = 0;
                            });
                          }
                        },
                        child: Text(
                          "Log In",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: fontSize*0.8
                          ),
                        )
                    ),
                    Text(
                        " instead?",
                        style: TextStyle(fontSize: fontSize*0.8)
                    )
                  ],
                ),
              ],
            ),
            TextFormField(
              onTap: () {

              },
              validator: (val) {
                if (val != null) {
                  if (!emailValid(val)) {
                    return "Email not formatted correctly";
                  }
                }
                return val == null || val.isEmpty
                    ? "Please provide an Email"
                    : null;
              },
              scrollPadding: const EdgeInsets.only(bottom: 200),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autofillHints: [AutofillHints.email],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: fontSize,
                  color: Colors.white
              ),
              decoration: textFieldInputDecoration("Email"),
            ),
            TextFormField(
              onTap: () {

              },
              validator: (val) {
                if (val != null) {
                  if (emailValid(val)) {
                    return "username cannot be formatted as an email";
                  }
                }
                return val == null || val.isEmpty
                    ? "Please provide a username"
                    : null;
              },
              scrollPadding: const EdgeInsets.only(bottom: 150),
              keyboardType: TextInputType.name,
              autofillHints: [AutofillHints.username],
              controller: usernameController,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: fontSize,
                  color: Colors.white
              ),
              decoration: textFieldInputDecoration("Username"),
            ),
            TextFormField(
              onTap: () {

              },
              obscureText: true,
              validator: (val) {
                return val == null || val.isEmpty
                    ? "Please provide a password"
                    : null;
              },
              onFieldSubmitted: (value) {
                if (!isLoading) {
                  signUpFlutterBird();
                }
              },
              scrollPadding: const EdgeInsets.only(bottom: 100),
              controller: password2Controller,
              autofillHints: [AutofillHints.newPassword],
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: fontSize,
                  color: Colors.white
              ),
              decoration: textFieldInputDecoration("Password"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (!isLoading) {
                  signUpFlutterBird();
                }
              },
              style: buttonStyle(false, Colors.blue),
              child: Container(
                alignment: Alignment.center,
                width: width,
                height: 50,
                child: Text(
                  'Create free account',
                  style: simpleTextStyle(fontSize),
                ),
              ),
            )
          ]
      ),
    );
  }

  Widget login(double width, double fontSize) {
    return Form(
      key: formKeyLogin,
      child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize*1.5),
                ),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (!isLoading) {
                            setState(() {
                              signUpMode = 1;
                            });
                          }
                        },
                        child: Text(
                          "Create new Account",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: fontSize*0.8
                          ),
                        )
                    ),
                    Text(
                        " instead?",
                        style: TextStyle(fontSize: fontSize*0.8)
                    )
                  ],
                ),
              ],
            ),
            AutofillGroup(
              child: Column(
                children: [
                  TextFormField(
                    onTap: () {

                    },
                    validator: (val) {
                      return val == null || val.isEmpty
                          ? "Please provide an Email or Username"
                          : null;
                    },
                    focusNode: _focusEmail,
                    scrollPadding: const EdgeInsets.only(bottom: 160),
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: [
                      AutofillHints.email,
                      AutofillHints.username
                    ],
                    textInputAction: TextInputAction.next,
                    controller: emailOrUsernameController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: fontSize,
                        color: Colors.white
                    ),
                    decoration:
                    textFieldInputDecoration("Email or Username"),
                  ),
                  TextFormField(
                    onTap: () {

                    },
                    onFieldSubmitted: (value) {
                      if (!isLoading) {
                        signInFlutterBird();
                      }
                    },
                    obscureText: true,
                    validator: (val) {
                      return val == null || val.isEmpty
                          ? "Please provide a password"
                          : null;
                    },
                    scrollPadding: const EdgeInsets.only(bottom: 110),
                    focusNode: _focusPassword,
                    autofillHints: [AutofillHints.password],
                    onEditingComplete: () => TextInput.finishAutofillContext(),
                    controller: password1Controller,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: fontSize,
                        color: Colors.white
                    ),
                    decoration:
                    textFieldInputDecoration("Password"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (!isLoading) {
                            setState(() {
                              signUpMode = 2;
                            });
                          }
                        },
                        child: Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.blue, fontSize: fontSize*0.8),
                        )
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (!isLoading) {
                  signInFlutterBird();
                }
              },
              style: buttonStyle(false, Colors.blue),
              child: Container(
                alignment: Alignment.center,
                width: width,
                height: 50,
                child: Text(
                  'Login',
                  style: simpleTextStyle(fontSize),
                ),
              ),
            ),
          ]
      ),
    );
  }

  Widget loginScreen(double width, double loginBoxSize, double fontSize) {
    return NotificationListener(
        child: SingleChildScrollView(
          controller: _controller,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/brocast_transparent.png")
                ),
                signUpMode == 0 ? login(width - (30 * 2), fontSize) : Container(),
                signUpMode == 1 ? register(width - (30 * 2), fontSize) : Container(),
                signUpMode == 2 && !passwordResetSend ? resetPassword(width - (30 * 2), fontSize) : Container(),
                signUpMode == 2 && passwordResetSend ? resetPasswordEmailSend(width - (30 * 2), fontSize) : Container(),
                signUpMode != 2 ? loginAlternatives(loginBoxSize, fontSize) : Container(),
                signUpMode != 2 ? justPlayGame(width, fontSize) : Container(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
        onNotification: (t) {
          checkTopBottomScroll();
          return true;
        }
    );
  }

  Widget LoginOrRegisterBox(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    double totalHeight = MediaQuery.of(context).size.height;
    double heightScale = totalHeight / 800;
    double fontSize = 16 * heightScale;
    normalMode = true;
    double loginBoxSize = 100;
    double width = 800;
    double height = (MediaQuery.of(context).size.height / 10) * 9;
    // When the width is smaller than this we assume it's mobile.
    if (totalWidth <= 800 || totalHeight > totalWidth) {
      width = MediaQuery.of(context).size.width - 50;
      height = MediaQuery.of(context).size.height - 150;
      loginBoxSize = 50;
      // double newHeightScaleFont = width / 800;
      // fontSize = 16 * newHeightScaleFont;
    }
    return Align(
      alignment: FractionalOffset.center,
      child: showLoginScreen ? Container(
          width: width,
          height: height,
          child: CustomPaint(
              painter: BoxWindowPainter(showTop: showTopScoreScreen, showBottom: showBottomScoreScreen),
              child: loginScreen(width, loginBoxSize, fontSize))
      ) : Container(),
    );
  }

  Widget LoginOrRegisterScreen(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.7),
        child: Center(
            child: TapRegion(
                onTapOutside: (tap) {
                  goBack();
                },
                child: LoginOrRegisterBox(context)
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.center,
      child: showLoginScreen ? LoginOrRegisterScreen(context) : Container()
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(
        url,
        webOnlyWindowName: '_self'
    )) {
      throw 'Could not launch $url';
    }
  }
}
