import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/services/game_settings.dart';

class BirdOutline extends SpriteAnimationComponent with HasGameRef<FlutterBird> {

  Vector2 initialPos;
  BirdOutline({
    required this.initialPos,
  }) : super(size: Vector2(95, 70));

  double heightScale = 1;

  late GameSettings gameSettings;

  @override
  Future<void> onLoad() async {
    gameSettings = GameSettings();
    loadBird("bird_outline_animation.png");

    priority = 3;
    return super.onLoad();
  }

  setInitialPos(Vector2 initialPosition) {
    initialPos = initialPosition;
  }

  setSize(Vector2 newSize) {
    size = newSize;
    size.x = (size.x / 17) * 19;
    size.y = (size.y / 12) * 14;
  }

  loadBird(String birdImageName) async {
    final image = await Flame.images.load(birdImageName);
    animation = SpriteAnimation.fromFrameData(image, SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.10,
      textureSize: Vector2(19, 14),
    ));
    anchor = Anchor.center;

    heightScale = gameRef.size.y / 800;

    size.y = (gameRef.size.y / 10000) * 466;
    size.x = (size.y / 12) * 17;
    size.x = (size.x / 17) * 19;
    size.y = (size.y / 12) * 14;

    position = Vector2(initialPos.x, initialPos.y);
    position.x -= 1;
    position.y -= 1;
  }

  double flapSpeed = 600;
  double velocityY = 0;
  double accelerationY = 5000;
  double rotation = 0;
  gameStarted() {
    flapSpeed = 600;
    velocityY = 0;
    accelerationY = 5000;
    rotation = 0;
  }

  reset(double screenSizeY) {
    heightScale = screenSizeY / 800;

    size.y = (screenSizeY / 10000) * 466;
    size.x = (size.y / 12) * 17;
    size.x = (size.x / 17) * 19;
    size.y = (size.y / 12) * 14;

    position = Vector2(initialPos.x, initialPos.y);
    position.x -= 1;
    position.y -= 1;
    flapSpeed = 600;
    velocityY = 0;
    accelerationY = 5000;
    rotation = 0;
  }

  double startupTimer = 0.5;
  @override
  void update(double dt) {
    if (startupTimer > 0) {
      startupTimer -= dt;
      return;
    }
    if (!gameRef.gameStarted && !gameRef.gameEnded) {
      super.update(dt);
    } else {
      super.update(dt);
    }
  }

  fly() {
    velocityY = flapSpeed * -1;
  }

  changeBird() {
    loadBird("bird_outline_animation.png");
    priority = 3;
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    heightScale = gameSize.y / 800;
    if (!gameRef.gameStarted) {
      position = Vector2(initialPos.x, initialPos.y);
      position.x -= 1;
      position.y -= 1;
    }
  }
}
