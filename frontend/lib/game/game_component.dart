import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionplanet/app/constants.dart';
import 'package:tensionplanet/components/backgrounds/village_background.dart';
import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/extensions/logical_keyboard_key_extension.dart';
import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/json/json_match.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/utils/assets.dart';
import 'package:tensionplanet/utils/palette.dart';
import 'package:tensionplanet/utils/style.dart';

class GameComponent extends FlameGame
    with HasTappables, KeyboardEvents, MouseMovementDetector {
  final GameState state;
  final Component _layerSprites = Component(priority: 0);
  final Component _layerDebug = Component(priority: 3)
    ..positionType = PositionType.viewport;
  bool clickHandled = false;
  late final Vector2 viewPortSize;

  GameComponent(this.state);

  @override
  Future onLoad() async {
    await addBaseComponents(state.jsonMatch);

    final VillageBackground villageBackground = VillageBackground(
      image: Assets.IMAGES_BACKGROUNDS_VILLAGE,
      size: viewPortSize,
    );
    addComponent(villageBackground);

    final Building headquarters = Building(
      buildingType: BuildingType.headquarters,
      position: Vector2(viewPortSize.x / 2, viewPortSize.y / 2),
    );
    addComponent(headquarters);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    print(dt);
  }

  Future addBaseComponents(JsonMatch jsonMatch) async {
    viewPortSize = Vector2(
      (size.x / size.y) * Constants.VIEWPORT_SIZE,
      Constants.VIEWPORT_SIZE,
    );
    camera.viewport = FixedResolutionViewport(viewPortSize);

    _layerDebug.add(FpsTextComponent(
      position: Vector2(
        size.x - 20,
        size.y - 20,
      ),
      anchor: Anchor.centerRight,
      textRenderer: Style.textRenderer(size: 20),
    ));

    add(_layerSprites);
    add(_layerDebug);

    state.setLoaded();
  }

  @override
  Color backgroundColor() => Palette.black;

  void addComponent(Component component) {
    _layerSprites.add(component);
  }

  void removeComponent(Component component) {
    _layerSprites.remove(component);
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    super.onTapUp(pointerId, info);

    if (!clickHandled) {
      // TODO(momo): handle
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
