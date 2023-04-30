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
    anchor = Anchor.center;

    if (zone.status.isUnexplored) {
      add(ZoneUnexploredComponent());
    }

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

    if (hovered && (opacity < 1)) {
      opacity = (opacity + dt).clamp(0, 1);
    } else if (!hovered && (opacity > 0)) {
      opacity = (opacity - (dt * 3)).clamp(0, 1);
    }
  }
}

class ZoneUnexploredComponent extends SpriteComponent {
  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_MAPS_MISC_ZONE_UNEXPLORED);
    anchor = Anchor.center;

    return super.onLoad();
  }
}
