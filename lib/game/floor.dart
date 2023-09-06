
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';

class Floor extends RectangleComponent with HasGameRef<FlutterBird> {

  Floor();

  @override
  Future<void> onLoad() async {
    double height = gameRef.size.y;
    double floorHeight = gameRef.size.y * 0.785;
    double restHeight = height - floorHeight;
    position = Vector2(0, floorHeight);
    size = Vector2(gameRef.size.x, restHeight);
    add(RectangleHitbox());
    return super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    // super.render(canvas); // don't draw anything, handled by the parallax sky component
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    double height = gameSize.y;
    double floorHeight = gameSize.y * 0.785;
    double restHeight = height - floorHeight;
    position = Vector2(0, floorHeight);
    size = Vector2(gameSize.x, restHeight);
  }

}
