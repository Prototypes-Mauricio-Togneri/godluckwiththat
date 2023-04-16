import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionplanet/extensions/sprite_component_extension.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/types/building_type.dart';

class Building extends SpriteComponent
    with HasGameRef<GameComponent>, Tappable {
  final BuildingType buildingType;

  Building({
    required this.buildingType,
    required super.position,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(buildingType.sprite);
    size = getSize();
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    print(dt);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    gameRef.clickHandled = true;

    return true;
  }
}
