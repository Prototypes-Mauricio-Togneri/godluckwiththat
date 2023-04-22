import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionplanet/app/constants.dart';
import 'package:tensionplanet/components/zone_background.dart';
import 'package:tensionplanet/extensions/component_extension.dart';
import 'package:tensionplanet/extensions/logical_keyboard_key_extension.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/models/zone.dart';
import 'package:tensionplanet/utils/assets.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/utils/style.dart';

class GameComponent extends FlameGame
    with HasTappables, KeyboardEvents, MouseMovementDetector {
  final Component layerSprites = Component(priority: 0);
  final Component layerDebug = Component(priority: 3)
    ..positionType = PositionType.viewport;
  bool clickHandled = false;
  late final Vector2 viewPortSize;

  static late GameComponent instance;

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
    viewPortSize = Vector2(
      (size.x / size.y) * Constants.VIEWPORT_SIZE,
      Constants.VIEWPORT_SIZE,
    );
    camera.viewport = FixedResolutionViewport(viewPortSize);

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
  }

  @override
  Color backgroundColor() => Palette.black;

  void addComponent(Component component) {
    layerSprites.add(component);
  }

  void removeComponent(Component component) {
    layerSprites.remove(component);
  }

  void loadZone(Zone zone) {
    layerSprites.removeAllComponents();

    final ZoneBackground zoneBackground = ZoneBackground(
      image: Assets.IMAGES_BACKGROUNDS_ZONE,
      size: viewPortSize,
    );
    addComponent(zoneBackground);

    for (final Building building in zone.buildings) {
      addComponent(building.sprite);
    }
  }

  void showBuildingQuickMenu(Building building) {
    layerSprites.removeAllComponents();
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
