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

    for (int i = -9; i <= -8; i++) {
      for (int j = -5; j <= -4; j++) {
        add(Patch(
          i: i,
          j: j,
          resourceType: ResourceType.red,
        ));
        add(Mine(
          i: i,
          j: j,
          resourceType: ResourceType.red,
          gameState: gameState,
        ));
      }
    }

    for (int i = 9; i <= 10; i++) {
      for (int j = -7; j <= -6; j++) {
        add(Patch(
          i: i,
          j: j,
          resourceType: ResourceType.green,
        ));
        add(Mine(
          i: i,
          j: j,
          resourceType: ResourceType.green,
          gameState: gameState,
        ));
      }
    }

    for (int i = 1; i <= 2; i++) {
      for (int j = 6; j <= 7; j++) {
        add(Patch(
          i: i,
          j: j,
          resourceType: ResourceType.blue,
        ));
        add(Mine(
          i: i,
          j: j,
          resourceType: ResourceType.blue,
          gameState: gameState,
        ));
      }
    }

    return super.onLoad();
  }

  @override
  Color backgroundColor() => const Color(0xff1a1a1a);
}
