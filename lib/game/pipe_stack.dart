import 'dart:math';

import 'package:age_of_gold/game/flutter_bird.dart';
import 'package:age_of_gold/game/pipe.dart';
import 'package:flame/components.dart';

class PipeStack extends PositionComponent with HasGameRef<FlutterBird> {
  static final Random _rng = Random();

  @override
  Future<void> onLoad() async {
    final isBottom = _rng.nextBool();
    position.x = gameRef.size.x;
    final gameHeight = gameRef.size.y;
    final boxHeight = Pipe.initialSize.y;
    final maxStackHeight = (gameRef.size.y / Pipe.initialSize.y).floor() - 2;
    final stackHeight = _rng.nextInt(maxStackHeight + 1);
    final boxSpacing = boxHeight * (2 / 3);
    final initialY = isBottom ? gameHeight - boxHeight : -boxHeight / 3;
    final boxes = List.generate(stackHeight, (i) {
      return Pipe(
        position: Vector2(0, initialY + i * boxSpacing * (isBottom ? -1 : 1)),
      );
    });
    addAll(isBottom ? boxes : boxes.reversed);
  }

  @override
  void update(double dt) {
    if (position.x < -Pipe.initialSize.x) {
      removeFromParent();
    }
    position.x -= gameRef.speed * dt;
  }
}