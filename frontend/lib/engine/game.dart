import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:tensionnode/engine/hq.dart';
import 'package:tensionnode/engine/hud.dart';
import 'package:tensionnode/engine/mine.dart';
import 'package:tensionnode/engine/patch.dart';
import 'package:tensionnode/engine/zoomable.dart';
import 'package:tensionnode/types/resource_type.dart';

class MyGame extends Zoomable with HasTappables {
  @override
  Future onLoad() async {
    add(FpsTextComponent(position: Vector2(10, 10)));
    add(Hud(size.x / 2));

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

    return super.onLoad();
  }

  @override
  Color backgroundColor() => const Color(0xff1a1a1a);
}
