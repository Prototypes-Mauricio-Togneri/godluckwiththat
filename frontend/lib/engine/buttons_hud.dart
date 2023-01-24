import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:tensionnode/engine/game.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/services/assets.dart';

class ButtonsHud extends SpriteComponent with HasGameRef<MyGame> {
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

    add(ButtonComponent());

    return super.onLoad();
  }
}

class ButtonComponent extends SpriteGroupComponent<ButtonState>
    with HasGameRef<MyGame>, Tappable {
  ButtonComponent() {
    positionType = PositionType.viewport;
    priority = 1;
  }

  @override
  Future onLoad() async {
    position = Vector2(10, 10);
    width = 60;
    height = 60;

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

    //MainMenu.show(game: game);

    return true;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    current = ButtonState.down;

    return true;
  }
}
