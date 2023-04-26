import 'package:flame/components.dart';
import 'package:gatewayguardians/extensions/sprite_component_extension.dart';
import 'package:gatewayguardians/json/json_map_zone.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/assets.dart';

class ZoneComponent extends SpriteComponent {
  final Zone zone;
  final JsonMapZone mapZone;
  final String image;
  late final ZoneHoveredComponent zoneHoveredComponent;

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
    opacity = 0;

    zoneHoveredComponent = ZoneHoveredComponent(position: size / 2);
    add(zoneHoveredComponent);

    return super.onLoad();
  }

  void onHoverEnter() => zoneHoveredComponent.onHoverEnter();

  void onHoverLeave() => zoneHoveredComponent.onHoverLeave();
}

class ZoneHoveredComponent extends SpriteComponent {
  bool hovered = false;

  ZoneHoveredComponent({
    required super.position,
  });

  @override
  Future onLoad() async {
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
