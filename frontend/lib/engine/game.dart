import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:tensionnode/engine/hq.dart';
import 'package:tensionnode/engine/mine.dart';
import 'package:tensionnode/engine/patch.dart';
import 'package:tensionnode/engine/zoomable.dart';
import 'package:tensionnode/types/resource_type.dart';

class MyGame extends Zoomable with HasTappables {
  @override
  Future onLoad() async {
    super.onLoad();
    add(FpsTextComponent(position: Vector2(10, 10)));

    /*for (int x = 0; x < 20; x++) {
      for (int y = 0; y < 20; y++) {
        add(Mine(
          i: x,
          j: y,
          path: 'mine_red.png',
          resourceType: ResourceType.red,
        ));
      }
    }*/

    add(Headquarters(
      i: 0,
      j: 0,
    ));

    add(Patch(
      i: -8,
      j: -5,
      path: 'patch_red.png',
      resourceType: ResourceType.red,
    ));
    add(Patch(
      i: -8,
      j: -4,
      path: 'patch_red.png',
      resourceType: ResourceType.red,
    ));
    add(Patch(
      i: -9,
      j: -5,
      path: 'patch_red.png',
      resourceType: ResourceType.red,
    ));
    add(Patch(
      i: -9,
      j: -4,
      path: 'patch_red.png',
      resourceType: ResourceType.red,
    ));

    add(Mine(
      i: -8,
      j: -5,
      path: 'mine_red.png',
      resourceType: ResourceType.red,
    ));
    add(Mine(
      i: -8,
      j: -4,
      path: 'mine_red.png',
      resourceType: ResourceType.red,
    ));
    add(Mine(
      i: -9,
      j: -5,
      path: 'mine_red.png',
      resourceType: ResourceType.red,
    ));
    add(Mine(
      i: -9,
      j: -4,
      path: 'mine_red.png',
      resourceType: ResourceType.red,
    ));
  }

  @override
  Color backgroundColor() => const Color(0xff1a1a1a);
}
