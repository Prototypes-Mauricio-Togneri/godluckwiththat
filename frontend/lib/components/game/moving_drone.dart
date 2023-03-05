import 'package:flame/components.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/extensions/sprite_component_extension.dart';
import 'package:tensionnode/game/game_component.dart';
import 'package:tensionnode/models/drone.dart';

class MovingDrone extends SpriteComponent with HasGameRef<GameComponent> {
  final Drone drone;
  Vector2 origin;
  late Node target;
  Vector2 direction = Vector2.zero();
  double distanceToTarget = 0;
  double progress = 0;
  final List<Node> waypoints;

  MovingDrone({
    required this.drone,
    required this.waypoints,
    required Node nodeOrigin,
  }) : origin = nodeOrigin.position {
    _routeFrom(origin);
  }

  bool get hasWaypoints => waypoints.isNotEmpty;

  @override
  Future onLoad() async {
    sprite = await getSprite(game.state.research.droneSprite);
    size = getSize();
    anchor = Anchor.center;

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);

    progress += (dt / distanceToTarget) * game.state.research.droneSpeed;
    position = origin + (direction * progress);

    if (progress >= 1) {
      target.receiveMovingDrone(this);
      _routeFrom(target.position);
    }
  }

  void _routeFrom(Vector2 newOrigin) {
    if (waypoints.isNotEmpty) {
      origin = newOrigin;
      target = waypoints.removeAt(0);

      progress = 0;
      direction = target.position - origin;
      distanceToTarget = direction.length / Constants.NODE_SIZE;
    } else {
      parent!.remove(this);
    }
  }

  void sendBack({
    required Node nodeDeleted,
    required Node headquarters,
  }) {
    if ((target == nodeDeleted) || (waypoints.contains(nodeDeleted))) {
      origin = position.clone();
      target = headquarters;
      waypoints.clear();

      progress = 0;
      direction = target.position - origin;
      distanceToTarget = direction.length / Constants.NODE_SIZE;
    }
  }
}
