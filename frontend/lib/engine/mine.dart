import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/widgets.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/cell.dart';
import 'package:tensionnode/engine/game.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/services/assets.dart';
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
    print('$i $j');

    add(MineMenu());

    return true;
  }
}

class MineMenu extends SpriteComponent with HasGameRef<MyGame> {
  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_HUD);
    width = 100;
    height = 100;
    positionType = PositionType.game;
    position = Vector2(Constants.CELL_SIZE, Constants.CELL_SIZE);
    anchor = Anchor.topLeft;

    add(ButtonComponent(_onCloseMenu));

    return super.onLoad();
  }

  void _onCloseMenu() => removeFromParent();
}

class ButtonComponent extends SpriteGroupComponent<ButtonState>
    with HasGameRef<MyGame>, Tappable {
  final VoidCallback onClick;

  ButtonComponent(this.onClick);

  @override
  Future onLoad() async {
    width = 60;
    height = 60;
    positionType = PositionType.game;
    position = Vector2(10, 10);
    anchor = Anchor.topLeft;

    sprites = {
      ButtonState.down: await getSprite(Assets.IMAGES_BUTTON_MENU_DOWN),
      ButtonState.up: await getSprite(Assets.IMAGES_BUTTON_MENU_UP),
    };

    current = ButtonState.up;

    return super.onLoad();
  }

  @override
  bool onTapUp(TapUpInfo info) {
    current = ButtonState.up;

    onClick();

    return true;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    current = ButtonState.down;

    return true;
  }
}
