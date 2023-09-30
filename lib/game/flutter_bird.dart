import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/game/bird.dart';
import 'package:flutter_bird/game/floor.dart';
import 'package:flutter_bird/game/help_message.dart';
import 'package:flutter_bird/game/pipe_duo.dart';
import 'package:flutter_bird/game/score_indicator.dart';
import 'package:flutter_bird/models/user.dart';
import 'package:flutter_bird/services/game_settings.dart';
import 'package:flutter_bird/services/rest/auth_service_flutter_bird.dart';
import 'package:flutter_bird/services/settings.dart';
import 'package:flutter_bird/services/user_score.dart';
import 'package:flutter_bird/views/user_interface/score_screen/score_screen_change_notifier.dart';
import 'sky.dart';

class FlutterBird extends FlameGame with TapDetector, HasCollisionDetection {

  FocusNode gameFocus;
  FlutterBird(this.gameFocus);

  bool playFieldFocus = true;

  late final Bird bird;

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

  bool playSounds = true;
  double soundVolume = 1.0;

  int score = 0;

  late AudioPool pointPool;
  late AudioPool diePool;
  late AudioPool hitPool;

  double deathTimer = 1;
  bool death = false;
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

  @override
  Future<void> onLoad() async {
    sky = Sky();
    bird = Bird();
    helpMessage = HelpMessage();
    scoreIndicator = ScoreIndicator();
    add(sky);
    add(bird);
    add(Floor());
    add(helpMessage);
    add(ScreenHitbox());

    heightScale = size.y / 800;
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
    newPipeDuo.pipePassed();
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
    clearPipes();
    bird.reset();
    sky.reset();
    if (scoreScreenChangeNotifier.getScoreScreenVisible()) {
      scoreScreenChangeNotifier.setScoreScreenVisible(false);
    }
  }

  @override
  Future<void> onTap() async {
    if (!gameStarted && !gameEnded) {
      // start game
      gameStarted = true;
      death = false;
      deathTimer = 1;
      bird.gameStarted();
      remove(helpMessage);
      add(scoreIndicator);
      scoreRemoved = false;
      spawnInitialPipes();
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
    super.onTap();
  }

  gameOver() async {
    if (gameStarted && !gameEnded) {
      if (playSounds) {
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
  }

  removePipe(PipeDuo pipeDuo) {
    pipes.remove(pipeDuo);
    remove(pipeDuo);
  }

  Future<void> spawnInitialPipes() async {
    double pipeX = pipeBuffer;
    PipeDuo newPipeDuo = PipeDuo(
      position: Vector2(pipeX, 0),
      pipeType: pipeType,
    );
    add(newPipeDuo);
    lastPipeDuo = newPipeDuo;
    pipes.add(newPipeDuo);
    print("pipeInterval: $pipeInterval");
    print("width ${size.x}");

    pipeX -= pipeInterval;
    double birdPos = (size.x / 10);
    while(pipeX > birdPos + pipeInterval) {
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
    } else if (gameEnded) {
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
        }
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
      if (pipe.passed) {
        continue;
      }
      // bird.position.x will always be 100 in this case.
      if (pipe.position.x < bird.position.x) {
        pipe.pipePassed();
        score += 1;
        scoreIndicator.scoreChange(score);
        pipesCleared += 1;
        if (playSounds) {
          // FlameAudio.play("point.wav", volume: soundVolume);
          pointPool.start(volume: soundVolume);
        }
      }
    }
  }

  checkOutOfBounds() {
    // There is a bug where the bird can go out of bounds when the frame rate drops and the
    // acceleration gets super high. The collision with the screen is not triggered and the
    // bird flies below all the pipes and gets all the points.
    // We add this simple check to ensure that this bug is not exploited.
    if (bird.position.y < -100) {
      gameOver();
    } else if (bird.position.y > (size.y + 100)) {
      gameOver();
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    heightScale = gameSize.y / 800;
    double pipe_width = (52 * heightScale) * 1.5;
    pipeInterval = (pipeGap * heightScale) + pipe_width;
    pipeBuffer = gameSize.x + pipeInterval;
    super.onGameResize(gameSize);
  }

  settingsChangeListener() {
    if (gameSettings.getBirdType() != bird.getBirdType()) {
      bird.changeBird(gameSettings.getBirdType());
    }
    if (gameSettings.getBackgroundType() != sky.getBackgroundType()) {
      sky.changeBackground(gameSettings.getBackgroundType());
    }
    if (gameSettings.getPipeType() != pipeType) {
      pipeType = gameSettings.getPipeType();
      clearPipes();
    }
  }

  changeBird(int birdType) async {
    gameSettings.setBirdType(birdType);
    bird.changeBird(birdType);
  }

  changeBackground(int backgroundType) async {
    gameSettings.setBackgroundType(backgroundType);
    sky.changeBackground(backgroundType);
  }

  changePipes(int pipeType) async {
    gameSettings.setPipeType(pipeType);
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
}
