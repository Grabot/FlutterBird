
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class Pipe extends SpriteComponent {
  static Vector2 initialSize = Vector2.all(150);
  Pipe({super.position}) : super(size: Vector2.all(150));

  @override
  Future<void> onLoad() async {
    final image = await Flame.images.load('pipe.png');
    sprite = Sprite(image);
    add(RectangleHitbox());
    return super.onLoad();
  }
}
