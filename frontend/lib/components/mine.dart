import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/cell.dart';
import 'package:tensionnode/components/menu_button_component.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game.dart';
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
    if (children.query<MineMenu>().isEmpty) {
      game.removeComponents(MineMenu);
      add(MineMenu());
    }

    return true;
  }
}

class MineMenu extends SpriteComponent with HasGameRef<GameComponent> {
  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_HUD);
    width = 100 / game.camera.zoom;
    height = 100 / game.camera.zoom;
    positionType = PositionType.game;
    position = Vector2(Constants.CELL_SIZE, Constants.CELL_SIZE);
    anchor = Anchor.topLeft;

    add(MenuButtonComponent(
      originalWidth: 60,
      originalHeight: 60,
      positionType: PositionType.game,
      position: Vector2(10, 10),
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

    width = 100 / game.camera.zoom;
    height = 100 / game.camera.zoom;
  }
}
