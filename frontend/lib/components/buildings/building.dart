import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionplanet/extensions/sprite_component_extension.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/types/building_type.dart';

class Building extends SpriteComponent
    with HasGameRef<GameComponent>, Tappable {
  final BuildingType buildingType;
  int level;

  Building({
    required this.buildingType,
    required this.level,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(buildingType.sprite);
    size = getSize();
    position = Vector2(
      gameRef.size.x * buildingType.position.dx,
      gameRef.size.y * buildingType.position.dy,
    );
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  bool onTapUp(TapUpInfo info) {
    gameRef.clickHandled = true;

    return true;
  }
}
