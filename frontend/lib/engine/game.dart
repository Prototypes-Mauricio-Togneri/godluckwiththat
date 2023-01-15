import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:tensionnode/engine/mine.dart';

class MyGame extends FlameGame with TapDetector {
  @override
  Future<void> onLoad() async {
    add(Mine());
  }
}
