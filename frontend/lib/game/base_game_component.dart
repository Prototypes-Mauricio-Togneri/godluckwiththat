import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionnode/components/base/resources_hud.dart';
import 'package:tensionnode/game/component_handler.dart';
import 'package:tensionnode/game/game_state.dart';
import 'package:tensionnode/game/map_handler.dart';
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

  BaseGameComponent(this.state);

  Future addBaseComponents() async {
    add(FpsTextComponent(
      position: Vector2(
        10,
        size.y - 40,
      ),
      textRenderer: Style.textRenderer(size: 20),
    ));
    add(ResourcesHud());
    add(await getMap());
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
