import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bird/game/bird.dart';
import 'package:flutter_bird/game/floor.dart';
import 'package:flutter_bird/game/help_message.dart';
import 'package:flutter_bird/game/pipe_duo.dart';
import 'package:flutter_bird/game/score_indicator.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/game_settings.dart';
import 'package:flutter_bird/services/rest/auth_service_flutter_bird.dart';
import 'package:flutter_bird/services/rest/auth_service_leaderboard.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/user_score.dart';
import 'package:flutter_bird/util/util.dart';
import 'package:flutter_bird/views/user_interface/score_screen/score_screen_change_notifier.dart';
import 'sky.dart';

class FlutterBird extends FlameGame with MultiTouchTapDetector, HasCollisionDetection, KeyboardEvents {

  FocusNode gameFocus;
  FlutterBird(this.gameFocus);

  bool playFieldFocus = true;

  bool twoPlayers = false;
  late final Bird bird1;
  late final Bird bird2;

  bool gameStarted = false;
  bool gameEnded = false;
  double speed = 160;
  double heightScale = 1;

  PipeDuo? lastPipeDuo;
  double pipeBuffer = 1000;
  double pipeGap = 300;
  double pipeInterval = 0;

  late HelpMessage helpMessage;
  late Sky sky;
  late ScoreIndicator scoreIndicator;

  double timeSinceEnded = 0;

  double soundVolume = 1.0;

  int score = 0;

  late AudioPool pointPool;
  late AudioPool diePool;
  late AudioPool hitPool;

  double deathTimer = 1;
  bool death = false;
  bool deathTimeEnded = false;
  bool scoreRemoved = false;

  double frameTimes = 0.0;
  int frames = 0;
  int fps = 0;
  int variant = 0;

  List<PipeDuo> pipes = [];

  late ScoreScreenChangeNotifier scoreScreenChangeNotifier;
  late Settings settings;
  late GameSettings gameSettings;
  late UserScore userScore;

  int flutters = 0;
  int pipesCleared = 0;

  int pipeType = 0;

  bool dataLoaded = false;
  late Vector2 initialPosBird1;

  @override
  Future<void> onLoad() async {
    sky = Sky();
    heightScale = size.y / 800;

    Vector2 birdSize = Vector2(85, 60);
    birdSize.y = (size.y / 10000) * 466;
    birdSize.x = (birdSize.y / 12) * 17;

    // position the birds next to each other, with a little gap
    initialPosBird1 = Vector2(birdSize.x * 3 + 20, (size.y/3));
    Vector2 initialPosBird2 = Vector2(birdSize.x * 2 - 20, (size.y/3));
    bird1 = Bird(
        birdType: 0,
        initialPos: initialPosBird1
    );
    bird2 = Bird(
        birdType: 1,
        initialPos: initialPosBird2
    );
    helpMessage = HelpMessage();
    scoreIndicator = ScoreIndicator();
    add(sky);
    add(bird1);
    add(Floor());
    add(helpMessage);
    add(ScreenHitbox());

    double pipe_width = (52 * heightScale) * 1.5;
    pipeInterval = (pipeGap * heightScale) + pipe_width;
    pipeBuffer = size.x + pipeInterval;

    // We create a pipe off screen to the left,
    // this helps the creation of the pipes later for some reason
    double pipeX = -pipe_width-50;
    PipeDuo newPipeDuo = PipeDuo(
      position: Vector2(pipeX, 0),
      pipeType: pipeType,
    );
    newPipeDuo.pipePassedBird1();
    newPipeDuo.pipePassedBird2();
    add(newPipeDuo);

    pointPool = await FlameAudio.createPool(
      "point.wav",
      minPlayers: 0,
      maxPlayers: 4,
    );
    diePool = await FlameAudio.createPool(
      "die.wav",
      minPlayers: 0,
      maxPlayers: 4,
    );
    hitPool = await FlameAudio.createPool(
      "hit.wav",
      minPlayers: 0,
      maxPlayers: 4,
    );

    scoreScreenChangeNotifier = ScoreScreenChangeNotifier();
    settings = Settings();
    gameSettings = GameSettings();
    gameSettings.addListener(settingsChangeListener);
    userScore = UserScore();
    settingsChangeListener();
    dataLoaded = true;
    return super.onLoad();
  }

  startGame() {
    timeSinceEnded = 0;
    score = 0;
    gameEnded = false;
    add(helpMessage);
    if (!scoreRemoved) {
      scoreIndicator.scoreChange(0);
      remove(scoreIndicator);
    }
    scoreRemoved = true;
    deathTimeEnded = false;
    clearPipes();
    bird1.reset(size.y);
    if (twoPlayers) {
      bird2.reset(size.y);
    }
    sky.reset();
  }

  birdInteraction(Bird bird) {
    if (!gameStarted && !gameEnded) {
      // start game
      gameStarted = true;
      death = false;
      deathTimer = 1;
      bird1.gameStarted();
      if (twoPlayers) {
        bird2.gameStarted();
      }
      remove(helpMessage);
      add(scoreIndicator);
      scoreRemoved = false;
      spawnInitialPipes();
      bird.fly();
    } else if (!gameStarted && gameEnded) {
      // go to the main screen with help message
      if (timeSinceEnded < 0.4) {
        // We assume the user tried to fly
        return;
      }
      flutters = 0;
      pipesCleared = 0;
      startGame();
    } else if (gameStarted) {
      // game running
      bird.fly();
      flutters += 1;
    }
  }

  @override
  Future<void> onTapUp(int pointerId, TapUpInfo tapUpInfo) async {
    Vector2 screenPos = tapUpInfo.eventPosition.global;
    if (twoPlayers) {
      if (screenPos.x > size.x / 2) {
        birdInteraction(bird1);
      } else {
        birdInteraction(bird2);
      }
    } else {
      birdInteraction(bird1);
    }
    super.onTapUp(pointerId, tapUpInfo);
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    final isKeyDown = event is RawKeyDownEvent;
    print("on key event");
    if (!playFieldFocus && isKeyDown) {
      return KeyEventResult.ignored;
    } else {
      if (event.logicalKey == LogicalKeyboardKey.space && isKeyDown) {
        if (twoPlayers) {
          birdInteraction(bird2);
        }
      }
      return KeyEventResult.handled;
    }
  }

  gameOver() async {
    if (gameStarted && !gameEnded) {
      if (gameSettings.getSound()) {
        hitPool.start(volume: soundVolume);
        diePool.start(volume: soundVolume);
      }
      death = true;
      gameStarted = false;
      gameEnded = true;
      userScore.addTotalFlutters(flutters);
      userScore.addTotalPipesCleared(pipesCleared);
      userScore.addTotalGames(1);
      User? currentUser = settings.getUser();
      if (currentUser != null) {
        AuthServiceFlutterBird().updateUserScore(userScore.getScore()).then((result) {
          if (result.getResult()) {
            print("we have updated the score in the db");
          }
        });
      }
      sky.gameOver();
    }
  }

  Future<void> clearPipes() async {
    for (PipeDuo pipeDuo in pipes) {
      remove(pipeDuo);
    }
    pipes.clear();

    double pipe_width = (52 * heightScale) * 1.5;
    pipeInterval = (pipeGap * heightScale) + pipe_width;
    pipeBuffer = size.x + pipeInterval;
    // We create a pipe off screen to the left,
    // this helps the creation of the pipes later for some reason
    double pipeX = -pipe_width-50;
    PipeDuo newPipeDuo = PipeDuo(
      position: Vector2(pipeX, 0),
      pipeType: pipeType,
    );
    newPipeDuo.pipePassedBird1();
    newPipeDuo.pipePassedBird2();
    add(newPipeDuo);
  }

  removePipe(PipeDuo pipeDuo) {
    pipes.remove(pipeDuo);
    remove(pipeDuo);
  }

  Future<void> spawnInitialPipes() async {
    print("spawnInitialPipes");
    double pipeX = pipeBuffer;
    PipeDuo newPipeDuo = PipeDuo(
      position: Vector2(pipeX, 0),
      pipeType: pipeType,
    );
    add(newPipeDuo);
    lastPipeDuo = newPipeDuo;
    pipes.add(newPipeDuo);

    pipeX -= pipeInterval;
    while(pipeX > initialPosBird1.x + pipeInterval) {
      PipeDuo newPipeDuo = PipeDuo(
        position: Vector2(pipeX, 0),
        pipeType: pipeType,
      );
      add(newPipeDuo);
      pipes.add(newPipeDuo);
      pipeX -= pipeInterval;
    }
  }

  @override
  Future<void> update(double dt) async {
    super.update(dt);
    if (gameStarted) {
      if (lastPipeDuo != null) {
        if (lastPipeDuo!.position.x < pipeBuffer - pipeInterval) {
          PipeDuo newPipeDuo = PipeDuo(
            position: Vector2(pipeBuffer, 0),
            pipeType: pipeType,
          );
          add(newPipeDuo);
          pipes.add(newPipeDuo);
          lastPipeDuo = newPipeDuo;
        }
      }
      checkPipePassed();
      checkOutOfBounds();
    } else if (gameEnded && !deathTimeEnded) {
      bool isHighScore = false;
      if (score > userScore.getBestScore()) {
        isHighScore = true;
        userScore.setBestScore(score);
      }
      scoreScreenChangeNotifier.setScore(score, isHighScore);
      timeSinceEnded += dt;
      if (deathTimer <= 0) {
        // Show the game over screen
        if (!scoreRemoved) {
          scoreIndicator.scoreChange(0);
          remove(scoreIndicator);
        }
        scoreRemoved = true;
        if (!scoreScreenChangeNotifier.getScoreScreenVisible()) {
          scoreScreenChangeNotifier.setScoreScreenVisible(true);
          scoreScreenChangeNotifier.setTwoPlayer(twoPlayers);
          // update leaderboard score
          User? currentUser = Settings().getUser();
          if (currentUser != null) {
            // TODO: the user should have leaderboard content so we can already check if the user should be on it.
            print("going to update the leaderboard");
            if (!twoPlayers) {
              AuthServiceLeaderboard().updateLeaderboardOnePlayer(score).then((value) {
                if (value.getResult()) {
                  showToastMessage("${value.getMessage()} for one player");
                }
              });
            } else {
              AuthServiceLeaderboard().updateLeaderboardTwoPlayers(score).then((value) {
                if (value.getResult()) {
                  showToastMessage("${value.getMessage()} for two players");
                }
              });
            }
          }
        }
        deathTimeEnded = true;
      }
      deathTimer -= dt;
    }
    updateFps(dt);
  }

  updateFps(double dt) {
    frameTimes += dt;
    frames += 1;

    if (frameTimes >= 1) {
      fps = frames;
      print("fps: $fps");
      frameTimes = 0;
      frames = 0;
    }
  }

  checkPipePassed() {
    for (PipeDuo pipe in pipes) {
      if (twoPlayers) {
        if (pipe.passedBird1 && pipe.passedBird2) {
          continue;
        }
      } else {
        if (pipe.passedBird1) {
          continue;
        }
      }

      if ((pipe.position.x < bird1.position.x) && !pipe.passedBird1) {
        pipe.pipePassedBird1();
        score += 1;
        scoreIndicator.scoreChange(score);
        pipesCleared += 1;
        if (gameSettings.getSound()) {
          pointPool.start(volume: soundVolume);
        }
      }
      if (twoPlayers) {
        if (pipe.position.x < bird2.position.x) {
          pipe.pipePassedBird2();
          score += 1;
          scoreIndicator.scoreChange(score);
          pipesCleared += 1;
          if (gameSettings.getSound()) {
            pointPool.start(volume: soundVolume);
          }
        }
      }
    }
  }

  checkOutOfBounds() {
    // There is a bug where the bird can go out of bounds when the frame rate drops and the
    // acceleration gets super high. The collision with the screen is not triggered and the
    // bird flies below all the pipes and gets all the points.
    // We add this simple check to ensure that this bug is not exploited.
    if (bird1.position.y < -100) {
      gameOver();
    } else if (bird1.position.y > (size.y + 100)) {
      gameOver();
    }
    if (twoPlayers) {
      if (bird2.position.y < -100) {
        gameOver();
      } else if (bird2.position.y > (size.y + 100)) {
        gameOver();
      }
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    heightScale = gameSize.y / 800;
    double pipe_width = (52 * heightScale) * 1.5;
    pipeInterval = (pipeGap * heightScale) + pipe_width;
    pipeBuffer = gameSize.x + pipeInterval;
    Vector2 birdSize = Vector2(85, 60);
    birdSize.y = (gameSize.y / 10000) * 466;
    birdSize.x = (birdSize.y / 12) * 17;

    initialPosBird1 = Vector2(birdSize.x * 3 + 20, (gameSize.y/3));
    Vector2 initialPosBird2 = Vector2(birdSize.x * 2 - 20, (gameSize.y/3));
    if (dataLoaded) {
      bird1.setInitialPos(initialPosBird1);
      bird2.setInitialPos(initialPosBird2);
      bird1.reset(gameSize.y);
      bird2.reset(gameSize.y);
    }
    super.onGameResize(gameSize);
  }

  settingsChangeListener() {
    if (gameSettings.getPlayerType() != 0 && !twoPlayers) {
      twoPlayers = true;
      Vector2 birdSize = Vector2(85, 60);
      birdSize.y = (size.y / 10000) * 466;
      birdSize.x = (birdSize.y / 12) * 17;

      Vector2 initialPosBird2 = Vector2(birdSize.x * 2 - 20, (size.y/3));
      bird2.setInitialPos(initialPosBird2);
      bird2.reset(size.y);
      add(bird2);
    }
    if (gameSettings.getPlayerType() != 1 && twoPlayers) {
      twoPlayers = false;
      remove(bird2);
    }
    if (gameSettings.getBirdType1() != bird1.getBirdType()) {
      bird1.changeBird(gameSettings.getBirdType1());
    }
    if (gameSettings.getBirdType2() != bird2.getBirdType()) {
      bird2.changeBird(gameSettings.getBirdType2());
    }
    if (gameSettings.getBackgroundType() != sky.getBackgroundType()) {
      sky.changeBackground(gameSettings.getBackgroundType());
    }
    if (gameSettings.getPipeType() != pipeType) {
      pipeType = gameSettings.getPipeType();
      clearPipes();
    }
  }

  changePlayer(int playerType) async {
    if (playerType == 0) {
      twoPlayers = false;
      remove(bird2);
    } else {
      twoPlayers = true;
      Vector2 birdSize = Vector2(85, 60);
      birdSize.y = (size.y / 10000) * 466;
      birdSize.x = (birdSize.y / 12) * 17;

      Vector2 initialPosBird2 = Vector2(birdSize.x * 2 - 20, (size.y/3));
      bird2.setInitialPos(initialPosBird2);
      bird2.reset(size.y);
      add(bird2);
    }
  }

  changeBird1(int birdType1) async {
    bird1.changeBird(birdType1);
  }
  changeBird2(int birdType2) async {
    bird2.changeBird(birdType2);
  }

  changeBackground(int backgroundType) async {
    sky.changeBackground(backgroundType);
  }

  changePipes(int pipeType) async {
    this.pipeType = pipeType;
    clearPipes();
  }

  chatWindowFocus(bool chatWindowFocus) {
    playFieldFocus = !chatWindowFocus;
    if (playFieldFocus) {
      gameFocus.requestFocus();
    }
  }

  scoreScreenFocus(bool scoreScreenFocus) {
    playFieldFocus = !scoreScreenFocus;
    if (playFieldFocus) {
      gameFocus.requestFocus();
    }
  }

  chatBoxFocus(bool chatFocus) {
    playFieldFocus = !chatFocus;
    if (playFieldFocus) {
      gameFocus.requestFocus();
    }
  }

  profileFocus(bool profileFocus) {
    playFieldFocus = !profileFocus;
    if (playFieldFocus) {
      gameFocus.requestFocus();
    }
  }

  achievementBoxFocus(bool achievementBoxFocus) {
    playFieldFocus = !achievementBoxFocus;
    if (playFieldFocus) {
      gameFocus.requestFocus();
    }
  }

  loadingBoxFocus(bool loadingFocus) {
    playFieldFocus = !loadingFocus;
    if (playFieldFocus) {
      gameFocus.requestFocus();
    }
  }

  gameSettingsFocus(bool gameSettingsFocus) {
    playFieldFocus = !gameSettingsFocus;
    if (playFieldFocus) {
      gameFocus.requestFocus();
    }
  }

  leaderBoardFocus(bool leaderBoardFocus) {
    playFieldFocus = !leaderBoardFocus;
    if (playFieldFocus) {
      gameFocus.requestFocus();
    }
  }
}
