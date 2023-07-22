import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame/rendering.dart';
import 'package:gatewayguardians/extensions/sprite_component_extension.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/assets.dart';

class ZoneComponent extends PositionComponent {
  final Zone zone;
  late final ZoneHoveredComponent zoneHoveredComponent;
  late final ZoneUnexploredComponent zoneUnexploredComponent;

  static const double RADIUS = 160;

  ZoneComponent({
    required this.zone,
  });

  @override
  Future onLoad() async {
    position = Vector2(zone.x, zone.y);
    anchor = Anchor.center;

    zoneUnexploredComponent = ZoneUnexploredComponent();
    zoneHoveredComponent = ZoneHoveredComponent();

    if (!zone.isNeutral) {
      _checkBorder(zone.neighbor1, Assets.IMAGES_MAPS_MISC_BORDER1);
      _checkBorder(zone.neighbor2, Assets.IMAGES_MAPS_MISC_BORDER2);
      _checkBorder(zone.neighbor3, Assets.IMAGES_MAPS_MISC_BORDER3);
      _checkBorder(zone.neighbor4, Assets.IMAGES_MAPS_MISC_BORDER4);
      _checkBorder(zone.neighbor5, Assets.IMAGES_MAPS_MISC_BORDER5);
      _checkBorder(zone.neighbor6, Assets.IMAGES_MAPS_MISC_BORDER6);
    }

    if (zone.status.isUnexplored) {
      add(zoneUnexploredComponent);
    }

    add(zoneHoveredComponent);

    if (zone.status.isExplored) {
      for (final Patch patch in zone.patches) {
        if (patch.hasBuilding) {
          final Vector2 buildingPosition =
              (patch.location.offset * RADIUS).toVector2();

          add(ZoneBuildingComponent(
            building: patch.building!,
            position: buildingPosition,
          ));

          /*if (GameState.instance.selectedBuilding == patch.building) {
            add(ZoneElementSelectedComponent(position: buildingPosition));
          }*/
        } else {
          final Vector2 patchPosition =
              (patch.location.offset * RADIUS).toVector2();

          add(ZonePatchComponent(
            patch: patch,
            position: patchPosition,
          ));

          /*if (GameState.instance.selectedPatch == patch) {
            add(ZoneElementSelectedComponent(position: patchPosition));
          }*/
        }
      }
    }

    return super.onLoad();
  }

  bool containsPosition(Vector2 position) {
    final double distance = Vector2(x, y).distanceTo(position);

    return distance < RADIUS;
  }

  void onHoverEnter() => zoneHoveredComponent.onHoverEnter();

  void onHoverLeave() => zoneHoveredComponent.onHoverLeave();

  void _checkBorder(Zone? neighborZone, String image) {
    if ((neighborZone == null) || (neighborZone.colony != zone.colony)) {
      add(ZoneBorderComponent(
        image: image,
        color: zone.colony!.color,
      ));
    }
  }
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

class ZoneBorderComponent extends SpriteComponent {
  final String image;
  final Color color;

  ZoneBorderComponent({
    required this.image,
    required this.color,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(image);
    anchor = Anchor.center;
    opacity = 0.75;
    decorator.addLast(PaintDecorator.tint(color));

    return super.onLoad();
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

class ZonePatchComponent extends SpriteComponent with Tappable {
  final Patch patch;

  static const double RADIUS = 45;

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

  @override
  bool onTapDown(TapDownInfo info) {
    //GameState.instance.onPatchSelected(patch);

    return true;
  }

  bool containsPosition(Vector2 position) {
    final double distance = absolutePosition.distanceTo(position);

    return distance < RADIUS;
  }

  bool onHoverEnter() {
    decorator.addLast(PaintDecorator.tint(const Color(0x05000000)));

    return true;
  }

  bool onHoverLeave() {
    decorator.removeLast();

    return true;
  }
}

class ZoneBuildingComponent extends SpriteComponent with Tappable {
  final Building building;

  static const double RADIUS = 45;

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
    //GameState.instance.onBuildingSelected(building);

    return true;
  }

  bool containsPosition(Vector2 position) {
    final double distance = absolutePosition.distanceTo(position);

    return distance < RADIUS;
  }

  bool onHoverEnter() {
    decorator.addLast(PaintDecorator.tint(const Color(0x05000000)));

    return true;
  }

  bool onHoverLeave() {
    decorator.removeLast();

    return true;
  }
}

class ZoneElementSelectedComponent extends SpriteComponent {
  ZoneElementSelectedComponent({
    required super.position,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_MAPS_MISC_BUILDING_SELECTED);
    anchor = Anchor.center;

    return super.onLoad();
  }
}
