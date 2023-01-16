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
  final TextComponent redAmount = TextComponent();
  final TextComponent greenAmount = TextComponent();
  final TextComponent blueAmount = TextComponent();

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

    final TextPaint textPaint = TextPaint(
      style: const TextStyle(
        fontSize: 24,
        fontFamily: Constants.FONT_NAME,
        color: Palette.white,
      ),
    );

    redAmount.position = Vector2(60, 25);
    redAmount.anchor = Anchor.centerLeft;
    redAmount.textRenderer = textPaint;
    add(redAmount);

    add(ResourceIndicator(
      x: 40,
      y: 25,
      type: ResourceType.red,
    ));

    greenAmount.position = Vector2(210, 25);
    greenAmount.anchor = Anchor.centerLeft;
    greenAmount.textRenderer = textPaint;
    add(greenAmount);

    add(ResourceIndicator(
      x: 190,
      y: 25,
      type: ResourceType.green,
    ));

    blueAmount.position = Vector2(360, 25);
    blueAmount.anchor = Anchor.centerLeft;
    blueAmount.textRenderer = textPaint;
    add(blueAmount);

    add(ResourceIndicator(
      x: 340,
      y: 25,
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

class ResourceIndicator extends SpriteComponent {
  final ResourceType type;

  ResourceIndicator({
    required double x,
    required double y,
    required this.type,
  }) {
    position = Vector2(x, y);
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
