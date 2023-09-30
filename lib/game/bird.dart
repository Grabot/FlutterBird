import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter_bird/game/flutter_bird.dart';
import 'package:flutter_bird/services/game_settings.dart';

class Bird extends SpriteAnimationComponent with CollisionCallbacks, HasGameRef<FlutterBird> {

  int birdType;
  Vector2 initialPos;
  Bird({
    required this.birdType,
    required this.initialPos,
  }) : super(size: Vector2(85, 60));

  double heightScale = 1;

  late AudioPool wingPool;

  late GameSettings gameSettings;

  @override
  Future<void> onLoad() async {
    gameSettings = GameSettings();
    if (birdType == 0) {
      await loadBird("flutter_yellow.png");
    } else if (birdType == 1) {
      await loadBird("flutter_red.png");
    } else if (birdType == 2) {
      await loadBird("flutter_blue.png");
    }
    return super.onLoad();
  }

  loadBird(String birdImageName) async {
    add(CircleHitbox());

    final image = await Flame.images.load(birdImageName);
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

    position = Vector2(initialPos.x, initialPos.y);

    priority = 1;

    wingPool = await FlameAudio.createPool(
      "wing.wav",
      minPlayers: 0,
      maxPlayers: 4,
    );

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

    fly();
  }

  reset() {
    position = Vector2(initialPos.x, initialPos.y);
    flapSpeed = 600;
    velocityY = 0;
    accelerationY = 5000;
    rotation = 0;
  }

  @override
  onCollisionStart(_, __) async {
    // There can be multiple collisions after death, we only want to handle the first one
    if (!gameRef.gameEnded) {
      // For the death animation we set the velocity such that the bird flies up and then falls down
      velocityY = -1000;
      gameRef.gameOver();
    }
    super.onCollisionStart(_, __);
  }

  _updatePositionDeath(double dt) {
    double floorHeight = gameRef.size.y * 0.785;
    if (position.y >= floorHeight) {
      velocityY = 0;
      return;
    }
    velocityY -= (((accelerationY * dt) / 2) * -1);
    position.y -= ((velocityY * dt) * heightScale) * -1;

    rotation = ((velocityY * -1) / 12).clamp(-90, 90);
    angle = radians(rotation * -1);
  }

  _updatePositionGame(double dt) {
    velocityY -= (((accelerationY * dt) / 2) * -1);
    position.y -= ((velocityY * dt) * heightScale) * -1;

    rotation = ((velocityY * -1) / 12).clamp(-90, 20);
    angle = radians(rotation * -1);
  }

  _updatePositionMenu(double dt) {
    if ((position.y > ((gameRef.size.y/3) + (20 * heightScale))) && accelerationY > 0) {
      accelerationY *= -1;
    }
    if ((position.y < ((gameRef.size.y/3) - (20 * heightScale))) && accelerationY < 0) {
      accelerationY *= -1;
    }
    velocityY -= (((accelerationY * dt) / 2) * -1);
    velocityY = velocityY.clamp(-250, 250);
    position.y -= ((velocityY * dt) * heightScale) * -1;

    rotation = ((velocityY * -1) / 12).clamp(-90, 90);
    angle = radians(rotation * -1);
  }

  double startupTimer = 0.5;
  @override
  void update(double dt) {
    if (startupTimer > 0) {
      startupTimer -= dt;
      return;
    }
    if (!gameRef.gameStarted && !gameRef.gameEnded) {
      _updatePositionMenu(dt);
      super.update(dt);
    } else if (gameRef.gameEnded) {
      _updatePositionDeath(dt);
    } else {
      _updatePositionGame(dt);
      super.update(dt);
    }
  }

  fly() {
    velocityY = flapSpeed * -1;
    if (gameSettings.getSound()) {
      wingPool.start(volume: gameRef.soundVolume);
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    size.y = (gameSize.y / 10000) * 466;
    size.x = (size.y / 12) * 17;
    heightScale = gameSize.y / 800;

    if (!gameRef.gameStarted) {
      position = Vector2(initialPos.x, initialPos.y);
    }
  }

  changeBird(int newBirdType) async {
    if (newBirdType == 0 && newBirdType != birdType) {
      birdType = newBirdType;
      await loadBird("flutter_yellow.png");
    } else if (newBirdType == 1 && newBirdType != birdType) {
      birdType = newBirdType;
      await loadBird("flutter_red.png");
    } else if (newBirdType == 2 && newBirdType != birdType) {
      birdType = newBirdType;
      await loadBird("flutter_blue.png");
    }
  }

  int getBirdType() {
    return birdType;
  }
}
