
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/game/pipe.dart';

class PipeDuo extends PositionComponent with HasGameRef<FlutterBird> {

  PipeDuo({super.position});

  double pipe_gap = 300;
  double pipe_x = 0;

  double pipe_width = 52;
  double pipe_height = 400;

  static final Random _rng = Random();

  double heightScale = 1;

  Pipe? upper;
  Pipe? lower;

  double randomNumber = 0;

  double totalShiftX = 0;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    heightScale = gameRef.size.y / 800;

    pipe_height = (400 * heightScale) * 1.5;
    pipe_width = (52 * heightScale) * 1.5;

    randomNumber = _rng.nextDouble();

    spawnNewPipes();
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (position.x < -(pipe_x + pipe_width)) {
      removeFromParent();
    }
    double change = (gameRef.speed * dt) * heightScale;
    position.x -= change;
    totalShiftX += change;
    super.update(dt);
  }

  spawnNewPipes() {
    addAll(createRandomPipes());
  }

  List<Pipe> createRandomPipes() {

    double gap_y = randomNumber * (800 * heightScale) * 0.45 - (pipe_gap * heightScale);
    gap_y += ((800 * heightScale) * 0.5).toInt();

    pipe_x = position.x + pipe_width + (pipe_gap * heightScale);

    double uLower = (800 * heightScale) + (gap_y - (pipe_gap * heightScale));

    Pipe lower_pipe = Pipe(
      position: Vector2(pipe_x, uLower),
    );

    double yUpper = uLower - (pipe_gap * heightScale) - pipe_height;
    Pipe upper_pipe = Pipe(
      position: Vector2(pipe_x, yUpper),
    );

    upper = upper_pipe;
    lower = lower_pipe;
    return [lower!, upper!];
  }

  @override
  void onGameResize(Vector2 gameSize) {
    heightScale = gameSize.y / 800;

    double gap_y = randomNumber * (800 * heightScale) * 0.45 - (pipe_gap * heightScale);
    gap_y += ((800 * heightScale) * 0.5).toInt();

    double pipe_x = position.x + pipe_width + (pipe_gap * heightScale);

    double uLower = (800 * heightScale) + (gap_y - (pipe_gap * heightScale));
    double yUpper = uLower - (pipe_gap * heightScale) - pipe_height;

    if (lower != null) {
      double lowerX = pipe_x - totalShiftX;
      lower!.position.y = uLower;
      lower!.position.x = lowerX;
    }
    if (upper != null) {
      double upperX = pipe_x - totalShiftX;
      upper!.position.y = yUpper;
      upper!.position.x = upperX;
    }
    super.onGameResize(gameSize);
  }

}