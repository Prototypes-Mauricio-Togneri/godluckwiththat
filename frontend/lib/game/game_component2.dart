import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gatewayguardians/components/map_component.dart';
import 'package:gatewayguardians/components/zone_component.dart';
import 'package:gatewayguardians/extensions/logical_keyboard_key_extension.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/game/map_handler.dart';
import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/assets.dart';
import 'package:gatewayguardians/utils/style.dart';

class GameComponent2 extends FlameGame
    with
        MapHandler,
        HasTappables,
        HasHoverables,
        ScaleDetector,
        ScrollDetector,
        KeyboardEvents {
  final Component layerSprites = Component(priority: 0);
  final Component layerDebug = Component(priority: 3)
    ..positionType = PositionType.viewport;
  bool clickHandled = false;

  static late GameComponent2 instance;

  @override
  Future onLoad() async {
    _initialize();
    GameState.instance.load();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    GameState.instance.update(dt);
  }

  void _initialize() {
    camera.viewport = FixedResolutionViewport(size);
    camera.setRelativeOffset(Anchor.center);
    camera.speed = double.maxFinite;

    layerDebug.add(FpsTextComponent(
      position: Vector2(
        size.x - 20,
        size.y - 20,
      ),
      anchor: Anchor.centerRight,
      textRenderer: Style.textRenderer(size: 20),
    ));

    add(layerSprites);
    add(layerDebug);

    layerSprites.add(MapComponent(image: Assets.IMAGES_MAPS_CHAPTER1_MAP));
    layerSprites.add(ZoneComponent(
      image: Assets.IMAGES_MAPS_CHAPTER1_ZONE1,
      position: Vector2(85.295, 1375.670),
    ));

    /*camera.moveTo(Vector2(
      cameraLocation[0].toDouble(),
      cameraLocation[1].toDouble(),
    ));*/
    camera.zoom = 1;
    centerMap(Vector2(
      500,
      1600,
    ));
  }

  @override
  void onScroll(PointerScrollInfo info) => handleOnScroll(info);

  @override
  void onScaleStart(ScaleStartInfo info) => handleOnScaleStart(info);

  @override
  void onScaleUpdate(ScaleUpdateInfo info) => handleOnScaleUpdate(info);

  @override
  Color backgroundColor() => const Color(0xff006dff);

  void addComponent(Component component) {
    //layerSprites.add(component);
  }

  void removeComponent(Component component) {
    //layerSprites.remove(component);
  }

  void loadZone(Zone zone) {
    /*layerSprites.removeAllComponents();

    final ZoneBackground zoneBackground = ZoneBackground(
      image: Assets.IMAGES_BACKGROUNDS_ZONE,
      size: viewPortSize,
    );
    addComponent(zoneBackground);

    for (final Building building in zone.buildings) {
      addComponent(building.sprite);
    }*/
  }

  void showBuildingQuickMenu(Building building) {
    //layerSprites.removeAllComponents();
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);

    if (!clickHandled) {
      GameState.instance.onMapClicked();
    }

    clickHandled = false;
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final bool isKeyDown = event is RawKeyDownEvent;

    if (keysPressed.isEscape && isKeyDown) {
      // TODO(momo): open main menu
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
  }
}
