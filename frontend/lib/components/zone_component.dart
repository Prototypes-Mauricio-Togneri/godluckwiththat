import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:gatewayguardians/extensions/sprite_component_extension.dart';
import 'package:gatewayguardians/json/json_map_zone.dart';
import 'package:gatewayguardians/models/zone.dart';

class ZoneComponent extends SpriteComponent {
  final Zone zone;
  final JsonMapZone mapZone;
  final String image;

  ZoneComponent({
    required this.zone,
    required this.image,
    required this.mapZone,
    required super.position,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(image);
    anchor = Anchor.topLeft;

    return super.onLoad();
  }

  void onHoverEnter() {
    tint(const Color(0x33ffffff));
  }

  void onHoverLeave() {
    tint(const Color(0x00000000));
  }

  /*@override
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
  }*/
}
