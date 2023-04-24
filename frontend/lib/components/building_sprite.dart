import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:gatewayguardians/extensions/sprite_component_extension.dart';
import 'package:gatewayguardians/game/game_component.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/buildings/building.dart';

class BuildingSprite extends SpriteComponent with Tappable {
  final Building building;

  BuildingSprite(this.building);

  @override
  Future onLoad() async {
    sprite = await getSprite(building.buildingType.sprite);
    size = getSize();
    position = Vector2(
      GameComponent.instance.size.x * building.offset.dx,
      GameComponent.instance.size.y * building.offset.dy,
    );
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  bool onTapUp(TapUpInfo info) {
    GameComponent.instance.clickHandled = true;
    GameState.instance.onBuildingSelected(building);

    return true;
  }
}
