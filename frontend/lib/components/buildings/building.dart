import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:tensionplanet/extensions/sprite_component_extension.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/models/location.dart';
import 'package:tensionplanet/utils/assets.dart';

class Building extends SpriteComponent
    with HasGameRef<GameComponent>, Tappable {
  final Location location;
  final Inventory inventory;

  Building({
    required this.location,
    required this.inventory,
  });

  @override
  Future onLoad() async {
    sprite =
        await getSprite(Assets.IMAGES_BUILDINGS_ASSEMBLERS_BATTERY_ASSEMBLY);
    size = getSize();
    anchor = Anchor.center;
    position = location.position;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    print(dt);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    return true;
  }
}
