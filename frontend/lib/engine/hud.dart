import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';

class Hud extends SpriteComponent with Tappable {
  final double xPosition;

  Hud(this.xPosition) {
    positionType = PositionType.viewport;
    priority = 1;
  }

  @override
  Future onLoad() async {
    final Image image = await Flame.images.load('hud.png');
    sprite = Sprite(image);
    position = Vector2(xPosition, 25);
    width = 100;
    height = 50;
    anchor = Anchor.center;

    final TextComponent redAmount = TextComponent(text: 'red: 0');
    add(redAmount);

    return super.onLoad();
  }
}
