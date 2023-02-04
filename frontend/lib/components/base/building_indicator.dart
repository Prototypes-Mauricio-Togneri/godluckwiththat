import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:tensionnode/extensions/component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/services/environment.dart';
import 'package:tensionnode/spec/fixed_node_spec.dart';

class BuildingIndicator extends SpriteComponent with HasGameRef<GameComponent> {
  final FixedNodeSpec spec;

  BuildingIndicator({
    required this.spec,
  });

  @override
  Future onLoad() async {
    sprite = await getSprite(spec.type.spriteBase);
    size = getSize();
    anchor = Anchor.center;

    final double opacity = Environment.canShowBuildingIndicator ? 0.5 : 0;
    decorator.addLast(PaintDecorator.grayscale(opacity: opacity));

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
