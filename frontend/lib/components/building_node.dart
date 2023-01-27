import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/types/node_type.dart';

class BuildingNode extends SpriteComponent with HasGameRef<GameComponent> {
  final NodeType type;

  BuildingNode({
    required this.type,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(type.path);
    width = Constants.NODE_SIZE;
    height = Constants.NODE_SIZE;
    anchor = Anchor.center;
    decorator.addLast(PaintDecorator.grayscale(opacity: 0.5));

    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (game.mousePosition != null) {
      position = game.mousePosition!;
    }

    super.update(dt);
  }
}
