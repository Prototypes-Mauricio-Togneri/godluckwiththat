import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:tensionnode/engine/game.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/types/resource_type.dart';

class ButtonsHud extends SpriteComponent with HasGameRef<MyGame> {
  final double xPosition;
  final TextComponent redAmount = TextResourceIndicator(x: 60);

  ButtonsHud({
    required this.xPosition,
  }) {
    positionType = PositionType.viewport;
    priority = 1;
  }

  @override
  Future onLoad() async {
    final Image image = await Flame.images.load('hud.png');
    sprite = Sprite(image);
    position = Vector2(xPosition, game.size.y - 25);
    width = 450;
    height = 50;
    anchor = Anchor.center;

    add(redAmount);
    add(IconResourceIndicator(
      x: 40,
      type: ResourceType.red,
    ));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    redAmount.text = '${game.state.red}';
  }
}

class IconResourceIndicator extends SpriteComponent {
  final ResourceType type;

  IconResourceIndicator({
    required double x,
    required this.type,
  }) {
    position = Vector2(x, 25);
  }

  @override
  Future onLoad() async {
    final Image image = await Flame.images.load(type.pathPatch);
    sprite = Sprite(image);
    width = 25;
    height = 25;
    anchor = Anchor.center;

    return super.onLoad();
  }
}

class TextResourceIndicator extends TextComponent {
  TextResourceIndicator({
    required double x,
  }) {
    position = Vector2(x, 25);
    anchor = Anchor.centerLeft;
    textRenderer = Style.textRenderer(size: 20);
  }
}
