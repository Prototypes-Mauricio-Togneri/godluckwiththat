import 'package:flame/components.dart';
import 'package:gatewayguardians/extensions/sprite_component_extension.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/assets.dart';

class ZoneComponent extends PositionComponent {
  final Zone zone;
  late final ZoneHoveredComponent zoneHoveredComponent;

  ZoneComponent({
    required this.zone,
    required super.position,
  });

  @override
  Future onLoad() async {
    anchor = Anchor.topLeft;

    zoneHoveredComponent = ZoneHoveredComponent();
    add(zoneHoveredComponent);

    return super.onLoad();
  }

  void onHoverEnter() => zoneHoveredComponent.onHoverEnter();

  void onHoverLeave() => zoneHoveredComponent.onHoverLeave();
}

class ZoneHoveredComponent extends SpriteComponent {
  bool hovered = false;

  @override
  Future onLoad() async {
    position = Vector2(182, 158);
    sprite = await getSprite(Assets.IMAGES_MAPS_MISC_ZONE_HOVERED);
    anchor = Anchor.center;
    opacity = 0;

    return super.onLoad();
  }

  void onHoverEnter() {
    hovered = true;
  }

  void onHoverLeave() {
    hovered = false;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (hovered) {
      if (opacity < 1) {
        opacity = (opacity + dt).clamp(0, 1);
      }
    } else {
      if (opacity > 0) {
        opacity = (opacity - (dt * 3)).clamp(0, 1);
      }
    }
  }
}
