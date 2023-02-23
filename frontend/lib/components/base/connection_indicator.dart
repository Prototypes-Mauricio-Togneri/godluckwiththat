import 'package:flame/components.dart';
import 'package:flame/rendering.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/new_path.dart';
import 'package:tensionnode/services/assets.dart';
import 'package:tensionnode/services/environment.dart';

class ConnectionIndicator extends SpriteComponent
    with HasGameRef<GameComponent> {
  Location origin;

  ConnectionIndicator({
    required this.origin,
  });

  Location get target => Location.fromPosition(position);

  NewPath get newPath => NewPath(origin, target);

  void updateOrigin(Location newOrigin) {
    origin = newOrigin;
  }

  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_BUILDINGS_FLAG);
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
