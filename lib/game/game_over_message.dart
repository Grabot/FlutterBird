import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_bird/game/flutter_bird.dart';

class GameOverMessage extends SpriteComponent with HasGameRef<FlutterBird> {

  GameOverMessage();

  bool mobile = false;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    position = Vector2(gameRef.size.x/2, gameRef.size.y/2);
    position.y -= gameRef.size.y/6;

    double heightScale = gameRef.size.y / 800;
    size = Vector2(192 * heightScale * 1.5, 42 * heightScale * 1.5);

    var image = await Flame.images.load('gameover.png');
    sprite = Sprite(image);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 gameSize) async {
    position = Vector2(gameSize.x/2, gameSize.y/2);
    position.y -= gameSize.y/8;
    double heightScale = gameRef.size.y / 800;
    size = Vector2(192 * heightScale * 1.5, 42 * heightScale * 1.5);

    super.onGameResize(gameSize);
  }
}
