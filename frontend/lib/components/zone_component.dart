import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
import 'package:gatewayguardians/extensions/sprite_component_extension.dart';
import 'package:gatewayguardians/game/game_component.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/zone.dart';

class ZoneComponent extends SpriteComponent with Tappable, Hoverable {
  final Zone zone;
  final String image;

  ZoneComponent({
    required this.zone,
    required this.image,
    required super.position,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(image);
    anchor = Anchor.topLeft;

    return super.onLoad();
  }

  @override
  bool onHoverEnter(PointerHoverInfo info) {
    tint(const Color(0x33ffffff));

    return true;
  }

  @override
  bool onHoverLeave(PointerHoverInfo info) {
    tint(const Color(0x00000000));
    GameComponent.instance.mouseCursor = SystemMouseCursors.basic;

    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (isHovered) {
      GameComponent.instance.mouseCursor = SystemMouseCursors.grab;
    }
  }

  @override
  bool onTapUp(TapUpInfo info) {
    GameState.instance.onZoneSelected(zone);

    return true;
  }
}
