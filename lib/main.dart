import 'package:age_of_gold/game/flutter_bird.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(
      game: FlutterBird(),
    ),
  );
}
