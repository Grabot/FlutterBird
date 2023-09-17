
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_bird/game/bird.dart';
import 'package:flutter_bird/game/floor.dart';
import 'package:flutter_bird/game/game_over_message.dart';
import 'package:flutter_bird/game/help_message.dart';
import 'package:flutter_bird/game/pipe_duo.dart';
import 'package:flutter_bird/game/score_indicator.dart';
import 'sky.dart';

class FlutterBird extends FlameGame with TapDetector, HasCollisionDetection {

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
  late GameOverMessage gameOverMessage;
  late Sky sky;
  late ScoreIndicator scoreIndicator;

  double timeSinceEnded = 0;

  bool playSounds = true;
  double soundVolume = 1.0;

  int score = 0;

  late AudioPool pointPool;
  late AudioPool diePool;
  late AudioPool hitPool;

  @override
  Future<void> onLoad() async {
    sky = Sky();
    bird = Bird();
    helpMessage = HelpMessage();
    gameOverMessage = GameOverMessage();
    scoreIndicator = ScoreIndicator();
    add(sky);
    add(bird);
    add(Floor());
    add(helpMessage);
    add(ScreenHitbox());

    print("size ${size}");
    heightScale = size.y / 800;
    double pipe_width = (52 * heightScale) * 1.5;
    pipeInterval = (pipeGap * heightScale) + pipe_width;
    pipeBuffer = size.x;

    // We create a pipe off screen to the left,
    // this helps the creation of the pipes later for some reason
    double pipeX = -1000;
    PipeDuo newPipeDuo = PipeDuo(
      position: Vector2(pipeX, 0),
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

    return super.onLoad();
  }


  @override
  Future<void> onTap() async {
    if (!gameStarted && !gameEnded) {
      gameStarted = true;
      bird.gameStarted();
      remove(helpMessage);
      add(scoreIndicator);
      spawnInitialPipes();
    } else if (!gameStarted && gameEnded) {
      if (timeSinceEnded < 0.4) {
        // We assume the user tried to fly
        return;
      }
      timeSinceEnded = 0;
      score = 0;
      gameEnded = false;
      add(helpMessage);
      scoreIndicator.scoreChange(0);
      remove(scoreIndicator);
      remove(gameOverMessage);
      clearPipes();
      bird.reset();
      sky.reset();
    } else if (gameStarted) {
      // game running
      bird.fly();
    }
    super.onTap();
  }

  gameOver() {
    if (gameStarted && !gameEnded) {
      if (playSounds) {
        hitPool.start(volume: soundVolume);
        diePool.start(volume: soundVolume);
        // FlameAudio.play("hit.wav", volume: soundVolume);
        // FlameAudio.play("die.wav", volume: soundVolume);
      }
      gameStarted = false;
      gameEnded = true;
      add(gameOverMessage);
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

  List<PipeDuo> pipes = [];
  Future<void> spawnInitialPipes() async {
    double pipeX = pipeBuffer;
    PipeDuo newPipeDuo = PipeDuo(
      position: Vector2(pipeX, 0),
    );
    add(newPipeDuo);
    lastPipeDuo = newPipeDuo;
    pipes.add(newPipeDuo);
    while (pipeX > pipeInterval) {
      pipeX -= (pipeInterval / 2);
      PipeDuo newPipeDuo = PipeDuo(
        position: Vector2(pipeX, 0),
      );
      add(newPipeDuo);
      pipes.add(newPipeDuo);
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
          );
          add(newPipeDuo);
          pipes.add(newPipeDuo);
          lastPipeDuo = newPipeDuo;
        }
      }
      checkPipePassed();
    } else if (gameEnded) {
      timeSinceEnded += dt;
    }
    updateFps(dt);
  }

  double frameTimes = 0.0;
  int frames = 0;
  int fps = 0;
  int variant = 0;
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
      // bird.position.x will always be 200 in this case.
      if ((pipe.position.x + pipe.pipe_x) < bird.position.x) {
        pipe.pipePassed();
        score += 1;
        scoreIndicator.scoreChange(score);
        if (playSounds) {
          // FlameAudio.play("point.wav", volume: soundVolume);
          pointPool.start(volume: soundVolume);
        }
      }
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    heightScale = gameSize.y / 800;
    print("heightScale: $heightScale");
    double pipe_width = (52 * heightScale) * 1.5;
    pipeInterval = (pipeGap * heightScale) + pipe_width;
    super.onGameResize(gameSize);
  }
}
