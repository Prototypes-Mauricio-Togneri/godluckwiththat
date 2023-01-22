import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:tensionnode/engine/game.dart';
import 'package:tensionnode/extensions/component_extension.dart';

class ButtonsHud extends SpriteComponent with HasGameRef<MyGame> {
  ButtonsHud() {
    positionType = PositionType.viewport;
    priority = 1;
  }

  @override
  Future onLoad() async {
    sprite = await getSprite('hud.png');
    width = 450;
    height = 80;
    anchor = Anchor.center;
    position = Vector2(game.size.x / 2, game.size.y - (height / 2));

    add(ButtonComponent());

    return super.onLoad();
  }
}

class ButtonComponent extends SpriteGroupComponent<ButtonState> with Tappable {
  @override
  Future onLoad() async {
    position = Vector2(10, 10);
    width = 60;
    height = 60;

    sprites = {
      ButtonState.down: await getSprite('button_menu_down.png'),
      ButtonState.up: await getSprite('button_menu_up.png'),
    };

    current = ButtonState.up;
  }

  @override
  bool onTapUp(TapUpInfo info) {
    current = ButtonState.up;

    return true;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    current = ButtonState.down;

    return true;
  }
}
