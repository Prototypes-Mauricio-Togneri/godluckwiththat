import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:tensionplanet/extensions/sprite_component_extension.dart';
import 'package:tensionplanet/game/game_component.dart';
import 'package:tensionplanet/types/node_type.dart';
import 'package:tensionplanet/utils/environment.dart';

class BuildingIndicator extends SpriteComponent with HasGameRef<GameComponent> {
  final NodeType type;

  BuildingIndicator({
    required this.type,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(type.sprite);
    size = getSize();
    anchor = Anchor.center;

    final double opacity = Environment.canShowBuildingIndicator ? 0.5 : 0;
    decorator.addLast(PaintDecorator.grayscale(opacity: opacity));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (game.hasMousePosition) {
      position = game.mousePosition;
    }

    super.update(dt);
  }
}
