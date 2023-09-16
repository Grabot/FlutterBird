import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_bird/game/flutter_bird.dart';

class Bird extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef<FlutterBird> {

  Bird() : super(size: Vector2(85, 60));

  double heightScale = 1;

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    final image = await Flame.images.load('flutter_yellow.png');
    animation = SpriteAnimation.fromFrameData(image, SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.10,
      textureSize: Vector2(17, 12),
    ));

    heightScale = gameRef.size.y / 800;

    size.y = (gameRef.size.y / 10000) * 466;
    size.x = (size.y / 12) * 17;

    size.y = (size.y * heightScale);
    size.x = (size.x * heightScale);

    anchor = Anchor.center;

    double posY = (gameRef.size.y/3);
    position = Vector2(200, posY);

    return super.onLoad();
  }

  double flapSpeed = 600;
  double velocityY = 0;
  double accelerationY = 80;
  double rotation = 0;
  gameStarted() {
    flapSpeed = 600;
    velocityY = 0;
    accelerationY = 80;
    rotation = 0;

    fly();
  }

  reset() {
    double posY = (gameRef.size.y/3);
    position = Vector2(200, posY);
    flapSpeed = 600;
    velocityY = 0;
    accelerationY = 80;
    rotation = 0;
  }

  @override
  onCollisionStart(_, __) {
    gameRef.gameOver();
    // TODO: death animation
    super.onCollisionStart(_, __);
  }

  _updatePositionGame(double dt) {
    velocityY -= (accelerationY * -1);
    position.y -= ((velocityY * dt) * -1) * heightScale;

    rotation = ((velocityY * -1) / 12).clamp(-90, 20);
    angle = radians(rotation * -1);
  }

  double maxMenuVelY = 400;
  double minMenuVelY = -400;
  _updatePositionMenu(double dt) {
    if (velocityY > maxMenuVelY || velocityY < minMenuVelY) {
      accelerationY *= -1;
    }
    velocityY -= (accelerationY * -1);

    position.y -= ((velocityY * dt) * -1) * heightScale;
    rotation = ((velocityY * -1) / 12).clamp(-90, 20);
    angle = radians(rotation * -1);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!gameRef.gameStarted) {
      _updatePositionMenu(dt);
    } else {
      _updatePositionGame(dt);
    }
  }

  fly() {
    velocityY = flapSpeed * -1;
    if (gameRef.playSounds) {
      FlameAudio.play("wing.wav", volume: gameRef.soundVolume);
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    size.y = (gameSize.y / 10000) * 466;
    size.x = (size.y / 12) * 17;
    heightScale = gameSize.y / 800;

    if (!gameRef.gameStarted) {
      position = Vector2(200, (gameSize.y/3));
    }
  }
}
