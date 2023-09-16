
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_bird/game/flutter_bird.dart';

class Pipe extends SpriteComponent with HasGameRef<FlutterBird> {
  Pipe({super.position});

  double heightScale = 1;

  double originalSizeX = 0;
  double originalSizeY = 0;

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load('pipe-green_big.png');
    sprite = Sprite(image);
    anchor = Anchor.center;
    add(RectangleHitbox());
    heightScale = gameRef.size.y / 800;
    originalSizeX = size.x;
    originalSizeY = size.y;
    size.x *= 1.5;
    size.y *= 1.5;
    size.x *= heightScale;
    size.y *= heightScale;
    priority = 2;
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 gameSize) {
    heightScale = gameSize.y / 800;
    size.x = originalSizeX;
    size.y = originalSizeY;
    size.x *= 1.5;
    size.y *= 1.5;
    size.x *= heightScale;
    size.y *= heightScale;
    super.onGameResize(gameSize);
  }
}
