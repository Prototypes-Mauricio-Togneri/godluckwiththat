import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionplanet/extensions/sprite_component_extension.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/models/buildings/building.dart';

class BuildingSprite extends SpriteComponent
    with HasGameRef<GameComponent>, Tappable {
  final Building building;

  BuildingSprite(this.building);

  @override
  Future onLoad() async {
    sprite = await getSprite(building.buildingType.sprite);
    size = getSize();
    position = Vector2(
      gameRef.size.x * building.offset.dx,
      gameRef.size.y * building.offset.dy,
    );
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  bool onTapUp(TapUpInfo info) {
    gameRef.clickHandled = true;
    GameState.instance.onBuildingSelected(building);

    return true;
  }
}
