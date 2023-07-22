import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gatewayguardians/components/map_component.dart';
import 'package:gatewayguardians/components/zone_component.dart';
import 'package:gatewayguardians/extensions/component_extension.dart';
import 'package:gatewayguardians/extensions/logical_keyboard_key_extension.dart';
import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/game/map_handler.dart';
import 'package:gatewayguardians/json/json_map.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/utils/style.dart';

class GameComponent extends FlameGame
    with
        MapHandler,
        HasTappables,
        ScaleDetector,
        ScrollDetector,
        KeyboardEvents,
        MouseMovementDetector {
  final Component layerSprites = Component(priority: 0);
  final Component layerDebug = Component(priority: 3)
    ..positionType = PositionType.viewport;

  static late GameComponent instance;

  @override
  Future onLoad() async {
    _initialize(GameState.instance);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    GameState.instance.update(dt);
  }

  void _initialize(GameState state) {
    final JsonMap map = state.jsonMatch.map;
    final double width = map.height * (size.x / size.y) * 1.2;
    final double height = map.height.toDouble() * 1.2;

    camera.viewport = FixedResolutionViewport(Vector2(width, height));
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

    loadMap(state);

    camera.zoom = 1;
    centerMap(Vector2(
      map.width / 2,
      map.height / 2,
    ));
  }

  void loadMap(GameState state) {
    layerSprites.removeAllComponents();

    final JsonMap map = state.jsonMatch.map;
    layerSprites.add(MapComponent(image: '${map.path}/map.png'));

    for (final Zone zone in state.zones) {
      layerSprites.add(ZoneComponent(zone: zone));
    }
  }

  @override
  void onScroll(PointerScrollInfo info) => handleOnScroll(info);

  @override
  void onScaleStart(ScaleStartInfo info) => handleOnScaleStart(info);

  @override
  void onScaleUpdate(ScaleUpdateInfo info) => handleOnScaleUpdate(info);

  @override
  Color backgroundColor() => const Color(0xff006dff);

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);
    GameState.instance.onMapClicked(info.eventPosition.game);
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    GameState.instance.onMouseMoved(info.eventPosition.game);
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
