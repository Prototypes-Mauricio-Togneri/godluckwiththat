import 'package:flame/components.dart';
import 'package:tensionnode/components/menu_button_component.dart';
import 'package:tensionnode/dialog/main_menu.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game.dart';
import 'package:tensionnode/services/assets.dart';

class ButtonsHud extends SpriteComponent with HasGameRef<GameComponent> {
  ButtonsHud() {
    positionType = PositionType.viewport;
    priority = 1;
  }

  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_HUD);
    width = 450;
    height = 80;
    anchor = Anchor.center;
    position = Vector2(game.size.x / 2, game.size.y - (height / 2));

    add(MenuButtonComponent(
      originalSize: Vector2(60, 60),
      originalPosition: Vector2(10, 10),
      positionType: PositionType.viewport,
      spriteDown: Assets.IMAGES_BUTTON_MENU_DOWN,
      spriteUp: Assets.IMAGES_BUTTON_MENU_UP,
      onClick: _onOpenMainMenu,
    ));

    return super.onLoad();
  }

  void _onOpenMainMenu() => game.openMenu(MainMenu.NAME, true);
}
