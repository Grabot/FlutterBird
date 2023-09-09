
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_bird/game/flutter_bird.dart';

class Pipe extends SpriteComponent with HasGameRef<FlutterBird> {
  Pipe({super.position});

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load('pipe-green.png');
    final gameHeight = gameRef.size.y;
    sprite = Sprite(image);
    anchor = Anchor.center;
    add(RectangleHitbox());
    return super.onLoad();
  }
}
