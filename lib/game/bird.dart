import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_bird/game/flutter_bird.dart';

class Bird extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef<FlutterBird> {

  double flapSpeed = 800;
  double velocityY = 0;
  double accelerationY = 50;
  double rotation = 0;

  Bird() : super(size: Vector2(85, 60), position: Vector2(100, 100));

  @override
  Future<void> onLoad() async {
    debugPaint.strokeWidth = 5;
    debugMode = true;
    add(CircleHitbox()..debugPaint.strokeWidth = 5);
    final image = await Flame.images.load('flutter_yellow.png');
    animation = SpriteAnimation.fromFrameData(image, SpriteAnimationData.sequenced(
      amount: 3,
      stepTime: 0.10,
      textureSize: Vector2(17, 12),
    ));

    anchor = Anchor.center;
    flapSpeed = 800;
    velocityY = 0;
    accelerationY = 50;
    rotation = 0;

    return super.onLoad();
  }

  @override
  onCollisionStart(_, __) {
    // gameRef.pauseEngine();
    position.y = 0 ;
    super.onCollisionStart(_, __);
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocityY -= accelerationY * -1;
    position.y -= (velocityY * dt) * -1;

    rotation = ((velocityY * -1) / 12).clamp(-90, 20);
    angle = radians(rotation * -1);
  }

  fly() {
    velocityY = flapSpeed * -1;
  }
}
