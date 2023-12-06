import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flutter_bird/game/flutter_bird.dart';


class Sky extends ParallaxComponent<FlutterBird> with HasGameRef<FlutterBird> {

  int backgroundType = 0;

  @override
  Future<void> onLoad() async {
    await loadParallax(backgroundType);
  }

  loadParallax(int type) async {

    List parallaxList = [];
    if (type == 0) {
      parallaxList = [
        "parallax/city_day/city_bg_day_1.png",
        "parallax/city_day/city_bg_day_2.png",
        "parallax/city_bg_3.png",
        "parallax/city_bg_4.png",
      ];
    } else if (type == 1) {
      parallaxList = [
        "parallax/city_night/city_bg_night_1.png",
        "parallax/city_night/city_bg_night_2.png",
        "parallax/city_bg_3.png",
        "parallax/city_bg_4.png",
      ];
    }
    if (parallaxList.isNotEmpty && parallaxList.length == 4) {
      parallax = await gameRef.loadParallax(
        [
          ParallaxImageData(parallaxList[0]),
          ParallaxImageData(parallaxList[1]),
          ParallaxImageData(parallaxList[2]),
          ParallaxImageData(parallaxList[3]),
        ],
        baseVelocity: Vector2(20, 0),
        velocityMultiplierDelta: Vector2(1.8, 1.0),
        filterQuality: FilterQuality.none,
      );
    }
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

  changeBackground(int newBackgroundType) async {
    if (backgroundType != newBackgroundType) {
      await loadParallax(newBackgroundType);
      backgroundType = newBackgroundType;
    }
  }

  int getBackgroundType() {
    return backgroundType;
  }
}
