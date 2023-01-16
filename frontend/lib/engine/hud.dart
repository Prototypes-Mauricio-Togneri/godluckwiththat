import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flutter/painting.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/engine/game_state.dart';
import 'package:tensionnode/services/palette.dart';
import 'package:tensionnode/types/resource_type.dart';

class Hud extends SpriteComponent with Tappable {
  final double xPosition;
  final GameState gameState;
  final TextComponent redAmount = TextResourceIndicator(x: 60);
  final TextComponent greenAmount = TextResourceIndicator(x: 210);
  final TextComponent blueAmount = TextResourceIndicator(x: 360);

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
    width = 450;
    height = 50;
    anchor = Anchor.center;

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

    redAmount.text = '${gameState.red}';
    greenAmount.text = '${gameState.green}';
    blueAmount.text = '${gameState.blue}';
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
    final TextPaint textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 24,
        fontFamily: Constants.FONT_NAME,
        color: Palette.white,
      ),
    );

    position = Vector2(x, 25);
    anchor = Anchor.centerLeft;
    textRenderer = textPaint;
  }
}
