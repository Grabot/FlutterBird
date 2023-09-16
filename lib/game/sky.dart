import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter_bird/game/flutter_bird.dart';


class Sky extends ParallaxComponent<FlutterBird> {

  @override
  Future<void> onLoad() async {
    parallax = await gameRef.loadParallax(
      [
        ParallaxImageData('parallax/city_day/city_bg_day_1.png'),
        ParallaxImageData('parallax/city_day/city_bg_day_2.png'),
        ParallaxImageData('parallax/city_bg_3.png'),
        ParallaxImageData('parallax/city_bg_4.png'),
      ],
      baseVelocity: Vector2(20, 0),
      velocityMultiplierDelta: Vector2(1.8, 1.0),
      filterQuality: FilterQuality.none,
    );
  }

  gameOver() {
    if (parallax != null) {
      parallax!.baseVelocity = Vector2(0, 0);
    }
  }

  reset() {
    if (parallax != null) {
      parallax!.baseVelocity = Vector2(20, 0);
    }
  }
}
