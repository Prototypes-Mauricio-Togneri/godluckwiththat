import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/types/resource_type.dart';

class ResourcesHud extends PositionComponent with HasGameRef<GameComponent> {
  final TextComponent redAmount = TextResourceIndicator(x: 60);
  final TextComponent greenAmount = TextResourceIndicator(x: 210);
  final TextComponent blueAmount = TextResourceIndicator(x: 360);

  ResourcesHud() {
    positionType = PositionType.viewport;
    priority = 1;
  }

  @override
  Future onLoad() async {
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
    // TODO(momo): improvement: draw one single path instead of individual lines
    /*final Rect viewport = Rect.fromLTWH(
      camera.position.x,
      camera.position.y,
      camera.viewport.effectiveSize.x,
      camera.viewport.effectiveSize.y,
    );*/

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
    sprite = await getSprite(type.image);
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
