import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/painting.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/services/style.dart';

class WaveHud extends PositionComponent with HasGameRef<GameComponent> {
  final Rect _rect = const Rect.fromLTWH(0, 0, 300, 50);
  final Paint _paint = Paint();
  final TextComponent _text = TextComponent();

  WaveHud() {
    positionType = PositionType.viewport;
    priority = 1;

    _text.position = Vector2(15, 25);
    _text.anchor = Anchor.centerLeft;
    _text.textRenderer = Style.textRenderer(size: 20);

    _paint.color = Palette.grey;
    _paint.style = PaintingStyle.fill;
  }

  @override
  Future onLoad() async {
    width = 300;
    height = 50;
    anchor = Anchor.center;
    position = Vector2(width / 2, height / 2);

    add(_text);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    _text.text =
        'NEXT WAVE (${game.state.nextWave}): ${game.state.timeToNextWave}';
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(_rect, _paint);

    super.render(canvas);
  }
}
