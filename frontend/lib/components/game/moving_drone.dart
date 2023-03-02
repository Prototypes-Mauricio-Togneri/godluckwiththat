import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/services/assets.dart';

class MovingDrone extends SpriteComponent with HasGameRef<GameComponent> {
  Resource resource;
  Node origin;
  late Node target;
  Vector2 direction = Vector2.zero();
  double distanceToTarget = 0;
  double progress = 0;
  final List<Node> destinations;

  MovingDrone({
    required this.resource,
    required this.origin,
    required this.destinations,
  }) {
    _calculateRoute(origin);
  }

  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_RESOURCES_ENERGY);
    size = getSize();
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    progress += (dt / distanceToTarget) * Constants.CONSTRUCTION_DRONE_SPEED;
    position = origin.position +
        (direction * progress) +
        Vector2(Constants.NODE_SIZE / 2, Constants.NODE_SIZE / 2);

    if (progress >= 1) {
      target.receiveDrone(this);
      resource = Resource(resource.type, 0);
      _calculateRoute(target);
    }
  }

  void _calculateRoute(Node newOrigin) {
    if (destinations.isNotEmpty) {
      origin = newOrigin;
      target = destinations.removeAt(0);

      progress = 0;
      direction = target.position - origin.position;
      distanceToTarget = direction.length / Constants.NODE_SIZE;
    } else {
      parent!.remove(this);
    }
  }
}
