import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bird/game/flutter_bird.dart';

void main() {
  runApp(
    GameWidget(
      game: FlutterBird(),
    ),
  );
}
