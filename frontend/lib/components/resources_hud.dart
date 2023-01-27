import 'package:flame/components.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/style.dart';
import 'package:tensionnode/types/resource_type.dart';

class ResourcesHud extends SpriteComponent with HasGameRef<GameComponent> {
  final TextComponent redAmount = TextResourceIndicator(x: 60);
  final TextComponent greenAmount = TextResourceIndicator(x: 210);
  final TextComponent blueAmount = TextResourceIndicator(x: 360);

  ResourcesHud() {
    positionType = PositionType.viewport;
    priority = 1;
  }

  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_HUD);
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

    redAmount.text = '${game.state.red}';
    greenAmount.text = '${game.state.green}';
    blueAmount.text = '${game.state.blue}';
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
    sprite = await getSprite(type.pathPatch);
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
