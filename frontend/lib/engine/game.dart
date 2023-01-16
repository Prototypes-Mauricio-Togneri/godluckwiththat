import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:tensionnode/engine/hq.dart';
import 'package:tensionnode/engine/mine.dart';
import 'package:tensionnode/engine/zoomable.dart';
import 'package:tensionnode/types/resource_type.dart';

class MyGame extends Zoomable with HasTappables {
  @override
  Future onLoad() async {
    super.onLoad();
    add(FpsTextComponent(position: Vector2(10, 10)));

    for (int x = 0; x < 20; x++) {
      for (int y = 0; y < 20; y++) {
        add(Mine(
          i: x,
          j: y,
          path: 'red_mine.png',
          resourceType: ResourceType.red,
        ));
      }
    }

    add(Headquarters(
      i: 0,
      j: 0,
    ));
  }

  @override
  Color backgroundColor() => const Color(0xff333333);
}
