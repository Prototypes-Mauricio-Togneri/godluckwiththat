import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/cell.dart';
import 'package:tensionnode/components/menu_button_component.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/types/resource_type.dart';

class Mine extends Cell {
  final ResourceType resourceType;
  num accumulatedTime = 0;

  static const int RESOURCE_RED_COST = 100;

  Mine({
    required super.i,
    required super.j,
    required this.resourceType,
  }) : super(path: resourceType.pathMine);

  @override
  void update(double dt) {
    accumulatedTime += dt;

    if (accumulatedTime >= resourceType.productionTime) {
      accumulatedTime = 0;
      game.state.addResource(resourceType);
    }

    super.update(dt);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    if (children.query<MineMenu>().isEmpty) {
      game.removeComponents(MineMenu);
      game.add(MineMenu(
        i: i,
        j: j,
        position: position +
            Vector2(
              Constants.CELL_SIZE / 2,
              Constants.CELL_SIZE / 2,
            ),
      ));
    }

    return true;
  }
}

class MineMenu extends SpriteComponent with HasGameRef<GameComponent> {
  final int i;
  final int j;

  MineMenu({
    required this.i,
    required this.j,
    super.position,
  });

  @override
  Future onLoad() async {
    _updateSizeAndPosition();
    sprite = await getSprite(Assets.IMAGES_HUD);
    positionType = PositionType.game;
    anchor = Anchor.topLeft;
    priority = 1;

    add(MineText(
      originalPosition: Vector2(100, 15),
      text: 'Mine',
    ));

    add(MineText(
      originalPosition: Vector2(100, 45),
      text: 'Position: ($i, $j)',
    ));

    add(MenuButtonComponent(
      originalSize: Vector2(60, 60),
      originalPosition: Vector2(10, 110),
      positionType: PositionType.game,
      spriteDown: Assets.IMAGES_BUTTON_MENU_DOWN,
      spriteUp: Assets.IMAGES_BUTTON_MENU_UP,
      onClick: _onCloseMenu,
      resizeWithZoom: true,
    ));

    return super.onLoad();
  }

  void _onCloseMenu() => removeFromParent();

  @override
  void update(double dt) {
    super.update(dt);

    _updateSizeAndPosition();
  }

  void _updateSizeAndPosition() {
    width = 200 / game.camera.zoom;
    height = 200 / game.camera.zoom;
  }
}

class MineText extends TextComponent with HasGameRef<GameComponent> {
  final Vector2 originalPosition;

  MineText({
    required this.originalPosition,
    super.text,
  }) {
    anchor = Anchor.topCenter;
  }

  @override
  FutureOr<void> onLoad() {
    _updateSizeAndPosition();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _updateSizeAndPosition();
  }

  void _updateSizeAndPosition() {
    position.x = originalPosition.x / game.camera.zoom;
    position.y = originalPosition.y / game.camera.zoom;

    textRenderer = Style.textRenderer(size: 15 / game.camera.zoom);
  }
}
