
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter_bird/game/bird.dart';
import 'package:flutter_bird/game/floor.dart';
import 'package:flutter_bird/game/game_over_message.dart';
import 'package:flutter_bird/game/help_message.dart';
import 'package:flutter_bird/game/pipe_duo.dart';
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

  @override
  Future<void> onLoad() async {
    sky = Sky();
    bird = Bird();
    helpMessage = HelpMessage();
    gameOverMessage = GameOverMessage();
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
    add(newPipeDuo);
    return super.onLoad();
  }

  @override
  Future<void> onTap() async {
    if (!gameStarted && !gameEnded) {
      gameStarted = true;
      bird.gameStarted();
      remove(helpMessage);
      spawnInitialPipes();
    } else if (!gameStarted && gameEnded) {
      gameEnded = false;
      add(helpMessage);
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
