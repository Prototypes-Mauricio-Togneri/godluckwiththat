import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/input.dart';
import 'package:tensionnode/engine/game.dart';

class ButtonsHud extends SpriteComponent with HasGameRef<MyGame> {
  ButtonsHud() {
    positionType = PositionType.viewport;
    priority = 1;
  }

  @override
  Future onLoad() async {
    final Image image = await Flame.images.load('hud.png');
    sprite = Sprite(image);
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
  @override
  Future onLoad() async {
    final Sprite downSprite = await gameRef.loadSprite('button_menu_down.png');
    final Sprite upSprite = await gameRef.loadSprite('button_menu_up.png');

    position = Vector2(10, 10);
    width = 60;
    height = 60;

    sprites = {
      ButtonState.down: downSprite,
      ButtonState.up: upSprite,
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
