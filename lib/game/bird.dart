import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_bird/game/flutter_bird.dart';

class Bird extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef<FlutterBird> {

  double flapSpeed = 500;
  double velocityY = 0;
  double accelerationY = 50;
  double rotation = 0;

  Bird() : super(size: Vector2(85, 60));

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    final image = await Flame.images.load('flutter_yellow.png');
    animation = SpriteAnimation.fromFrameData(image, SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.10,
      textureSize: Vector2(17, 12),
    ));

    anchor = Anchor.center;

    double posY = (gameRef.size.y/4);
    position = Vector2(100, posY);

    return super.onLoad();
  }

  gameStarted() {
    flapSpeed = 500;
    velocityY = 0;
    accelerationY = 50;
    rotation = 0;
  }

  @override
  onCollisionStart(_, __) {
    // gameRef.pauseEngine();
    position.y = 0 ;
    super.onCollisionStart(_, __);
  }

  _updatePositionGame(double dt) {
    velocityY -= accelerationY * -1;
    position.y -= (velocityY * dt) * -1;

    rotation = ((velocityY * -1) / 12).clamp(-90, 20);
    angle = radians(rotation * -1);
  }

  double maxVelY = 400;
  double minVelY = -400;
  _updatePositionMenu(double dt) {
    if (velocityY > maxVelY || velocityY < minVelY) {
      accelerationY *= -1;
    }
    velocityY -= accelerationY * -1;

    position.y -= (velocityY * dt) * -1;
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
  }
}
