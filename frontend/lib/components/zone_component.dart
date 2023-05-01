import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:gatewayguardians/extensions/sprite_component_extension.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/assets.dart';

class ZoneComponent extends PositionComponent {
  final Zone zone;
  late final ZoneHoveredComponent zoneHoveredComponent;
  late final ZoneUnexploredComponent zoneUnexploredComponent;

  ZoneComponent({
    required this.zone,
    required super.position,
  });

  @override
  Future onLoad() async {
    anchor = Anchor.center;

    zoneUnexploredComponent = ZoneUnexploredComponent();
    zoneHoveredComponent = ZoneHoveredComponent();

    if (zone.status.isUnexplored) {
      add(zoneUnexploredComponent);
    }

    add(zoneHoveredComponent);

    for (final Patch patch in zone.patches) {
      if (patch.hasBuilding) {
        add(ZoneBuildingComponent(
          building: patch.building!,
          position: (patch.location.offset * Zone.RADIUS).toVector2(),
        ));
      } else {
        add(ZonePatchComponent(
          patch: patch,
          position: (patch.location.offset * Zone.RADIUS).toVector2(),
        ));
      }
    }

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

class ZonePatchComponent extends SpriteComponent {
  final Patch patch;

  ZonePatchComponent({
    required this.patch,
    required super.position,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(patch.patchType.sprite);
    anchor = Anchor.center;

    return super.onLoad();
  }
}

class ZoneBuildingComponent extends SpriteComponent with Tappable {
  final Building building;

  ZoneBuildingComponent({
    required this.building,
    required super.position,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(building.buildingType.sprite);
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  bool onTapDown(TapDownInfo info) {
    print('Clicked on ${building.buildingType.toString()}');
    GameState.instance.clickHandled = true;

    return true;
  }
}
