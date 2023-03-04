import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/drone.dart';
import 'package:tensionnode/services/assets.dart';

class MovingDrone extends SpriteComponent with HasGameRef<GameComponent> {
  final Drone drone;
  Node origin;
  late Node target;
  Vector2 direction = Vector2.zero();
  double distanceToTarget = 0;
  double progress = 0;
  final List<Node> waypoints;

  MovingDrone({
    required this.drone,
    required this.origin,
    required this.waypoints,
  }) {
    _routeFrom(origin);
  }

  @override
  Future onLoad() async {
    sprite = await getSprite(Assets.IMAGES_CONSTRUCTION_DRONE);
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
      target.receiveMovingDrone(this);
      drone.removeResource();
      _routeFrom(target);
    }
  }

  void _routeFrom(Node newOrigin) {
    if (waypoints.isNotEmpty) {
      origin = newOrigin;
      target = waypoints.removeAt(0);

      progress = 0;
      direction = target.position - origin.position;
      distanceToTarget = direction.length / Constants.NODE_SIZE;
    } else {
      parent!.remove(this);
    }
  }
}
