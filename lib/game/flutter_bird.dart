
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter_bird/game/bird.dart';
import 'package:flutter_bird/game/floor.dart';
import 'package:flutter_bird/game/help_message.dart';

import 'pipe_stack.dart';
import 'sky.dart';

class FlutterBird extends FlameGame with TapDetector, HasCollisionDetection {

  late final Bird bird;

  bool gameStarted = false;
  double speed = 160;

  double _timeSinceBox = 0;
  double _boxInterval = 1;

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
    return super.onLoad();
  }

  @override
  void onTap() {
    if (!gameStarted) {
      gameStarted = true;
      bird.gameStarted();
      remove(helpMessage);
    } else {
      // game running
      bird.fly();
    }
    super.onTap();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (gameStarted) {
      _timeSinceBox += dt;
      if (_timeSinceBox > _boxInterval) {
        add(PipeStack());
        _timeSinceBox = 0;
      }
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
  }
}
