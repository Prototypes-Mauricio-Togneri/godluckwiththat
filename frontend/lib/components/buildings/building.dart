import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/rendering.dart';
import 'package:tensionplanet/extensions/sprite_component_extension.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/models/village.dart';
import 'package:tensionplanet/types/building_type.dart';

class Building extends SpriteComponent
    with HasGameRef<GameComponent>, Tappable {
  final Village village;
  final BuildingType buildingType;
  final Offset offset;
  int level;

  Building({
    required this.village,
    required this.buildingType,
    required this.level,
    required this.offset,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(buildingType.sprite);
    size = getSize();
    position = Vector2(
      gameRef.size.x * offset.dx,
      gameRef.size.y * offset.dy,
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
