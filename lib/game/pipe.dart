import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_bird/game/flutter_bird.dart';

class Pipe extends SpriteComponent with HasGameRef<FlutterBird> {
  int birdType;

  Pipe({
    super.position,
    required this.birdType,
  });

  double heightScale = 1;

  double originalSizeX = 0;
  double originalSizeY = 0;


  @override
  Future<void> onLoad() async {
    await loadPipeDetails();
    return super.onLoad();
  }

  loadPipeDetails() async {
    if (birdType == 0) {
      final image = await Flame.images.load('pipe-red_big.png');
      sprite = Sprite(image);
    } else if (birdType == 1) {
      final image = await Flame.images.load('pipe-blue_big.png');
      sprite = Sprite(image);
    } else if (birdType == 2) {
      final image = await Flame.images.load('pipe-green_big.png');
      sprite = Sprite(image);
    } else if (birdType == 3) {
      final image = await Flame.images.load('pipe-yellow_big.png');
      sprite = Sprite(image);
    } else if (birdType == 4) {
      final image = await Flame.images.load('pipe-white_big.png');
      sprite = Sprite(image);
    } else if (birdType == 5) {
      final image = await Flame.images.load('pipe-black_big.png');
      sprite = Sprite(image);
    }
    anchor = Anchor.center;
    add(RectangleHitbox());
    heightScale = gameRef.size.y / 800;
    originalSizeX = size.x;
    originalSizeY = size.y;
    size.x *= 1.5;
    size.y *= 1.5;
    size.x *= heightScale;
    size.y *= heightScale;
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
