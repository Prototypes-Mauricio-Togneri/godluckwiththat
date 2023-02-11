import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flame_tiled_utils/flame_tiled_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/resources_hud.dart';
import 'package:tensionnode/components/base/wave_hud.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/game/component_handler.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/game/game_state.dart';
import 'package:tensionnode/game/map_handler.dart';
import 'package:tensionnode/json/json_match.dart';
import 'package:tensionnode/services/style.dart';

class BaseGameComponent extends FlameGame
    with
        MapHandler,
        ComponentHandler,
        HasTappables,
        HasHoverables,
        ScaleDetector,
        ScrollDetector,
        KeyboardEvents,
        MouseMovementDetector,
        HasCollisionDetection {
  final GameState state;
  final DebugText debugText = DebugText();

  BaseGameComponent(this.state);

  Future addBaseComponents(JsonMatch jsonMatch) async {
    camera.viewport = FixedResolutionViewport(size);
    camera.setRelativeOffset(Anchor.center);
    camera.speed = double.maxFinite;

    debugText.position = Vector2(
      size.x - 10,
      size.y - 20,
    );

    add(FpsTextComponent(
      position: Vector2(
        10,
        size.y - 30,
      ),
      textRenderer: Style.textRenderer(size: 20),
    ));
    add(debugText);
    add(WaveHud());
    add(ResourcesHud());

    final TiledComponent tiledComponent =
        await getMap(Constants.TEST_MAP_TILE_XML);
    final ImageBatchCompiler imageCompiler = ImageBatchCompiler();
    final PositionComponent ground = imageCompiler.compileMapLayer(
      tileMap: tiledComponent.tileMap,
      layerNames: ['ground'],
    );
    ground.priority = 0;
    add(ground);

    camera.moveTo(jsonMatch.map.position.vector);
    camera.zoom = jsonMatch.map.zoom.toDouble();
  }

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
    positionType = PositionType.viewport;
    anchor = Anchor.centerRight;
    priority = double.maxFinite.toInt();
    textRenderer = Style.textRenderer(size: 20);
  }

  @override
  void update(double dt) {
    super.update(dt);

    text = 'ENEMIES: ${game.state.enemies.length}';
  }
}
