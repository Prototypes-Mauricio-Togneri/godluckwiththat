import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:tensionnode/engine/mine.dart';
import 'package:tensionnode/engine/zoomable.dart';

class MyGame extends Zoomable with HasTappables {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(FpsTextComponent(position: Vector2(10, 10)));

    for (int x = 0; x < 25; x++) {
      for (int y = 0; y < 25; y++) {
        add(Mine(
          i: x,
          j: y,
        ));
      }
    }
  }

  @override
  Color backgroundColor() => const Color(0xffaaaaaa);
}
