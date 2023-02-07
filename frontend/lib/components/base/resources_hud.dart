import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/types/resource_type.dart';

class ResourcesHud extends PositionComponent with HasGameRef<GameComponent> {
  final Rect _rect = const Rect.fromLTWH(0, 0, 450, 50);
  final Paint _paint = Paint();
  final TextComponent _redAmount = TextResourceIndicator(x: 60);
  final TextComponent _greenAmount = TextResourceIndicator(x: 210);
  final TextComponent _blueAmount = TextResourceIndicator(x: 360);

  ResourcesHud() {
    positionType = PositionType.viewport;
    priority = 1;

    _paint.color = Palette.grey;
    _paint.style = PaintingStyle.fill;
  }

  @override
  Future onLoad() async {
    width = 450;
    height = 50;
    anchor = Anchor.center;
    position = Vector2(game.size.x / 2, height / 2);

    add(_redAmount);
    add(IconResourceIndicator(
      x: 40,
      type: ResourceType.red,
    ));

    add(_greenAmount);
    add(IconResourceIndicator(
      x: 190,
      type: ResourceType.green,
    ));

    add(_blueAmount);
    add(IconResourceIndicator(
      x: 340,
      type: ResourceType.blue,
    ));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _redAmount.text = '${game.state.resources.red}';
    _greenAmount.text = '${game.state.resources.green}';
    _blueAmount.text = '${game.state.resources.blue}';
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(_rect, _paint);

    super.render(canvas);
  }
}

class IconResourceIndicator extends PositionComponent {
  final Rect rect = const Rect.fromLTWH(0, 0, 20, 20);
  final Paint paint = Paint();
  final ResourceType type;

  IconResourceIndicator({
    required double x,
    required this.type,
  }) {
    width = 20;
    height = 20;
    anchor = Anchor.center;
    position = Vector2(x, 25);
    paint.color = type.color;
    paint.style = PaintingStyle.fill;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(rect, paint);

    super.render(canvas);
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
