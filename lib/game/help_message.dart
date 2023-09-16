import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter_bird/game/flutter_bird.dart';

class HelpMessage extends SpriteComponent with HasGameRef<FlutterBird> {

  HelpMessage();

  bool mobile = false;

  @override
  Future<void> onLoad() async {
    anchor = Anchor.center;
    // dirty check for phone or computer
    var image;
    if (gameRef.size.x < 800) {
      // web
      mobile = true;
      image = await Flame.images.load('message_phone.png');
    } else {
      // mobile
      image = await Flame.images.load('message_web.png');
    }
    // placed in the center with a size of 200x267
    position = Vector2(gameRef.size.x/2, gameRef.size.y/2);
    position.y -= gameRef.size.y/8;
    double heightScale = gameRef.size.y / 800;
    size = Vector2(200 * heightScale * 1.5, 267 * heightScale * 1.5);
    sprite = Sprite(image);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 gameSize) async {
    super.onGameResize(gameSize);
    position = Vector2(gameSize.x/2, gameSize.y/2);
    position.y -= gameSize.y/8;
    double heightScale = gameRef.size.y / 800;
    size = Vector2(200 * heightScale * 1.5, 267 * heightScale * 1.5);

    if (gameSize.x < 800 && !mobile) {
      mobile = true;
      var image = await Flame.images.load('message_phone.png');
      sprite = Sprite(image);
    } else if (gameSize.x >= 800 && mobile) {
      mobile = false;
      var image = await Flame.images.load('message_web.png');
      sprite = Sprite(image);
    }
  }
}
