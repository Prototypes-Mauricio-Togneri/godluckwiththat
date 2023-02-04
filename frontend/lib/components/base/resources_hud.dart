import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/types/resource_type.dart';

class ResourcesHud extends PositionComponent with HasGameRef<GameComponent> {
  final Rect rect = const Rect.fromLTWH(0, 0, 450, 50);
  final Paint paint = Paint();
  final TextComponent redAmount = TextResourceIndicator(x: 60);
  final TextComponent greenAmount = TextResourceIndicator(x: 210);
  final TextComponent blueAmount = TextResourceIndicator(x: 360);

  ResourcesHud() {
    positionType = PositionType.viewport;
    priority = 1;

    paint.color = Palette.grey;
    paint.style = PaintingStyle.fill;
  }

  @override
  Future onLoad() async {
    width = 450;
    height = 50;
    anchor = Anchor.center;
    position = Vector2(game.size.x / 2, height / 2);

    add(redAmount);
    add(IconResourceIndicator(
      x: 40,
      type: ResourceType.red,
    ));

    add(greenAmount);
    add(IconResourceIndicator(
      x: 190,
      type: ResourceType.green,
    ));

    add(blueAmount);
    add(IconResourceIndicator(
      x: 340,
      type: ResourceType.blue,
    ));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    redAmount.text = '${game.state.resources.red}';
    greenAmount.text = '${game.state.resources.green}';
    blueAmount.text = '${game.state.resources.blue}';
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(rect, paint);

    super.render(canvas);
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
    sprite = await getSprite(type.sprite);
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
