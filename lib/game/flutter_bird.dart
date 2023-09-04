
import 'package:age_of_gold/game/bird.dart';
import 'package:age_of_gold/game/pipe_stack.dart';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'sky.dart';

class FlutterBird extends FlameGame with TapDetector, HasCollisionDetection {

  late final Bird bird;

  double speed = 160;

  double _timeSinceBox = 0;
  double _boxInterval = 1;

  @override
  Future<void> onLoad() async {
    bird = Bird();
    add(Sky());
    add(bird);
    add(ScreenHitbox());
    return super.onLoad();
  }


  @override
  void onTap() {
    bird.fly();
    super.onTap();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timeSinceBox += dt;
    if (_timeSinceBox > _boxInterval) {
      add(PipeStack());
      _timeSinceBox = 0;
    }
  }
}
