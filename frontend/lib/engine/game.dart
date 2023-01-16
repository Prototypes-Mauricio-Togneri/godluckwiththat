import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:tensionnode/engine/game_state.dart';
import 'package:tensionnode/engine/hq.dart';
import 'package:tensionnode/engine/hud.dart';
import 'package:tensionnode/engine/mine.dart';
import 'package:tensionnode/engine/patch.dart';
import 'package:tensionnode/engine/zoomable.dart';
import 'package:tensionnode/types/resource_type.dart';

class MyGame extends Zoomable with HasTappables {
  final GameState gameState = GameState();

  @override
  Future onLoad() async {
    add(FpsTextComponent(position: Vector2(10, 10)));
    add(Hud(
      xPosition: size.x / 2,
      gameState: gameState,
    ));

    add(Headquarters(
      i: 0,
      j: 0,
    ));

    add(Patch(
      i: -8,
      j: -5,
      resourceType: ResourceType.red,
    ));
    add(Patch(
      i: -8,
      j: -4,
      resourceType: ResourceType.red,
    ));
    add(Patch(
      i: -9,
      j: -5,
      resourceType: ResourceType.red,
    ));
    add(Patch(
      i: -9,
      j: -4,
      resourceType: ResourceType.red,
    ));

    add(Mine(
      i: -8,
      j: -5,
      resourceType: ResourceType.red,
      gameState: gameState,
    ));
    add(Mine(
      i: -8,
      j: -4,
      resourceType: ResourceType.red,
      gameState: gameState,
    ));
    add(Mine(
      i: -9,
      j: -5,
      resourceType: ResourceType.red,
      gameState: gameState,
    ));
    add(Mine(
      i: -9,
      j: -4,
      resourceType: ResourceType.red,
      gameState: gameState,
    ));

    return super.onLoad();
  }

  @override
  Color backgroundColor() => const Color(0xff1a1a1a);
}
