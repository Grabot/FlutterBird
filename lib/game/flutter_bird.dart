
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter_bird/game/bird.dart';
import 'package:flutter_bird/game/floor.dart';
import 'package:flutter_bird/game/help_message.dart';
import 'package:flutter_bird/game/pipe_duo.dart';
import 'sky.dart';

class FlutterBird extends FlameGame with TapDetector, HasCollisionDetection {

  late final Bird bird;

  bool gameStarted = false;
  double speed = 160;
  double heightScale = 1;

  PipeDuo? lastPipeDuo;
  double pipeBuffer = 1000;
  double pipeGap = 300;
  double pipeInterval = 0;

  late HelpMessage helpMessage;

  @override
  Future<void> onLoad() async {
    bird = Bird();
    add(Sky());
    add(bird);
    add(Floor());
    helpMessage = HelpMessage();
    add(helpMessage);
    add(ScreenHitbox());

    print("size ${size}");
    heightScale = size.y / 800;
    double pipe_width = (52 * heightScale) * 1.5;
    pipeInterval = (pipeGap * heightScale) + pipe_width;
    pipeBuffer = size.x;

    // We create a pipe off screen to the left,
    // this helps the creation of the pipes later for some reason
    double pipeX = -800;
    PipeDuo newPipeDuo = PipeDuo(
      position: Vector2(pipeX, 0),
    );
    add(newPipeDuo);
    return super.onLoad();
  }

  @override
  Future<void> onTap() async {
    if (!gameStarted) {
      gameStarted = true;
      bird.gameStarted();
      remove(helpMessage);
      spawnInitialPipes();
    } else {
      // game running
      bird.fly();
    }
    super.onTap();
  }

  Future<void> spawnInitialPipes() async {
    // double pipeX = 200;
    // PipeDuo newPipeDuo = PipeDuo(
    //   position: Vector2(pipeX, 0),
    // );
    // add(newPipeDuo);

    double pipeX = pipeBuffer;
    PipeDuo newPipeDuo = PipeDuo(
      position: Vector2(pipeX, 0),
    );
    add(newPipeDuo);
    lastPipeDuo = newPipeDuo;
    while (pipeX > 200) {
      pipeX -= (pipeInterval / 2);
      PipeDuo newPipeDuo = PipeDuo(
        position: Vector2(pipeX, 0),
      );
      add(newPipeDuo);
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
