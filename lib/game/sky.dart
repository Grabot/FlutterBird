import 'dart:ui';

import 'package:age_of_gold/game/flutter_bird.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';


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
}
