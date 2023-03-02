import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/map_component.dart';
import 'package:tensionnode/components/game/moving_drone.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/game/game_state.dart';
import 'package:tensionnode/game/map_handler.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/services/style.dart';

class BaseGameComponent extends FlameGame
    with
        MapHandler,
        HasTappables,
        HasHoverables,
        ScaleDetector,
        ScrollDetector,
        KeyboardEvents,
        MouseMovementDetector,
        HasCollisionDetection {
  final GameState state;
  final Component _layerBackground = Component(priority: 0);
  final Component _layerPatches = Component(priority: 1);
  final Component _layerNodes = Component(priority: 2);
  final Component _layerRobots = Component(priority: 3);
  final Component _layerHud = Component(priority: 4)
    ..positionType = PositionType.viewport;

  BaseGameComponent(this.state);

  Component get layerNodes => _layerNodes;

  Future addBaseComponents(JsonMatch jsonMatch) async {
    camera.viewport = FixedResolutionViewport(size);
    camera.setRelativeOffset(Anchor.center);
    camera.speed = double.maxFinite;

    final MapComponent map = await getMap(Constants.TEST_MAP_TILE_XML);
    _addToBackgroundLayer(map.compile());

    _addToHudLayer(FpsTextComponent(
      position: Vector2(
        10,
        size.y - 30,
      ),
      textRenderer: Style.textRenderer(size: 20),
    ));

    add(_layerBackground);
    add(_layerPatches);
    add(_layerNodes);
    add(_layerRobots);
    add(_layerHud);

    final JsonLocation cameraLocation = jsonMatch.map.location;

    camera.moveTo(Vector2(
      cameraLocation[0].toDouble(),
      cameraLocation[1].toDouble(),
    ));
    camera.zoom = jsonMatch.map.zoom.toDouble();

    state.setLoaded();
  }

  @override
  Color backgroundColor() => Palette.gameBackground;

  void addComponent(Component component) {
    if (component is MovingDrone) {
      _layerRobots.add(component);
    } else {
      _layerNodes.add(component);
    }
  }

  void removeComponent(Component component) {
    if (component is MovingDrone) {
      _layerRobots.remove(component);
    } else {
      _layerNodes.remove(component);
    }
  }

  void addToPatchesLayer(Component component) => _layerPatches.add(component);

  void _addToBackgroundLayer(Component component) =>
      _layerBackground.add(component);

  void _addToHudLayer(Component component) => _layerHud.add(component);

  @override
  void onScroll(PointerScrollInfo info) => handleOnScroll(info);

  @override
  void onScaleStart(ScaleStartInfo info) => handleOnScaleStart(info);

  @override
  void onScaleUpdate(ScaleUpdateInfo info) => handleOnScaleUpdate(info);

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    onMapClicked(toGridPosition(info.eventPosition.game));
    super.onTapUp(pointerId, info);
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    super.onMouseMove(info);
    handleOnMouseMove(info);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) =>
      handleOnKeyEvent(event, keysPressed);
}
