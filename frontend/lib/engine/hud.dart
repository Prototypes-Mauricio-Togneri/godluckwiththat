import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/game_state.dart';
import 'package:tensionnode/services/palette.dart';

class Hud extends SpriteComponent with Tappable {
  final double xPosition;
  final GameState gameState;
  final TextComponent redAmount = TextComponent();

  Hud({
    required this.xPosition,
    required this.gameState,
  }) {
    positionType = PositionType.viewport;
    priority = 1;
  }

  @override
  Future onLoad() async {
    final Image image = await Flame.images.load('hud.png');
    sprite = Sprite(image);
    position = Vector2(xPosition, 25);
    width = 200;
    height = 50;
    anchor = Anchor.center;

    final TextPaint textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 24,
        fontFamily: Constants.FONT_NAME,
        color: Palette.white,
      ),
    );

    redAmount.position = Vector2(10, 25);
    redAmount.anchor = Anchor.centerLeft;
    redAmount.textRenderer = textPaint;
    add(redAmount);

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    redAmount.text = 'Red: ${gameState.red}';
  }
}
