import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
import 'package:gatewayguardians/extensions/sprite_component_extension.dart';
import 'package:gatewayguardians/game/game_component.dart';
import 'package:gatewayguardians/json/json_map_zone.dart';
import 'package:gatewayguardians/models/zone.dart';

class ZoneComponent extends SpriteComponent with Hoverable {
  final Zone zone;
  final String folder;
  final JsonMapZone mapZone;

  ZoneComponent({
    required this.zone,
    required this.folder,
    required this.mapZone,
    required super.position,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite('$folder/zone${zone.id}.png');
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
  void render(Canvas canvas) {
    super.render(canvas);

    canvas.drawCircle(
      const Offset(JsonMapZone.CENTER_X, JsonMapZone.CENTER_Y),
      JsonMapZone.RADIUS,
      paint..style = PaintingStyle.stroke,
    );
  }
}
