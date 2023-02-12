import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/map_component.dart';
import 'package:tensionnode/components/base/resources_hud.dart';
import 'package:tensionnode/components/base/wave_hud.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/game/game_state.dart';
import 'package:tensionnode/game/map_handler.dart';
import 'package:tensionnode/json/json_match.dart';
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
  final DebugText debugText = DebugText();
  final Component _layerBackground = Component(priority: 0);
  final Component _layerNodes = Component(priority: 1);
  final Component _layerHud = Component(priority: 2)
    ..positionType = PositionType.viewport;

  BaseGameComponent(this.state);

  Component get layerNodes => _layerNodes;

  Future addBaseComponents(JsonMatch jsonMatch) async {
    camera.viewport = FixedResolutionViewport(size);
    camera.setRelativeOffset(Anchor.center);
    camera.speed = double.maxFinite;

    debugText.position = Vector2(
      size.x - 30,
      size.y - 30,
    );

    final MapComponent map = await getMap(Constants.TEST_MAP_TILE_XML);
    addToBackgroundLayer(map.compile());

    addToHudLayer(WaveHud());
    addToHudLayer(ResourcesHud(
      position: Vector2(
        size.x / 2,
        25,
      ),
    ));
    addToHudLayer(debugText);
    addToHudLayer(FpsTextComponent(
      position: Vector2(
        10,
        size.y - 30,
      ),
      textRenderer: Style.textRenderer(size: 20),
    ));

    add(_layerBackground);
    add(_layerNodes);
    add(_layerHud);

    camera.moveTo(jsonMatch.map.position.vector);
    camera.zoom = jsonMatch.map.zoom.toDouble();

    state.setLoaded();
  }

  void addToBackgroundLayer(Component component) =>
      _layerBackground.add(component);

  void addToNodesLayer(Component component) => _layerNodes.add(component);

  void addToHudLayer(Component component) => _layerHud.add(component);

  void removeFromBackgroundLayer(Component component) =>
      _layerBackground.remove(component);

  void removeFromNodesLayer(Component component) =>
      _layerNodes.remove(component);

  void removeFromHudLayer(Component component) => _layerHud.remove(component);

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

class DebugText extends TextComponent with HasGameRef<GameComponent> {
  DebugText() {
    anchor = Anchor.centerRight;
    textRenderer = Style.textRenderer(size: 20);
  }

  @override
  void update(double dt) {
    super.update(dt);

    final int buildings =
        game.state.turrets.length + game.state.mines.length + 1;

    text = 'ENEMIES: ${game.state.enemies.length}\nBUILDINGS: $buildings\n';
  }
}
