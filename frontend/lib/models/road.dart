import 'package:flame/game.dart';
import 'package:tensionnode/app/constants.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/moving_resource.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/types/resource_type.dart';

class Road {
  final Node origin;
  final Node target;
  final num distance;

  Vector2 _direction = Vector2.zero();
  double _distance = 0;
  double _progress = 0;
  MovingResource? _movingResource;

  Road(this.origin, this.target)
      : distance = origin.location.distanceTo(target.location);

  bool get isAvailable => _movingResource == null;

  JsonLocation get json => target.location.json;

  void send(ResourceType resource) {
    _progress = 0;
    _movingResource = MovingResource(resource: resource);
    _direction = target.position - origin.position;
    _distance = _direction.length / Constants.NODE_SIZE;
    origin.game.addComponent(_movingResource!);
  }

  void update(double dt) {
    if (_movingResource != null) {
      _progress += (dt / _distance) * Constants.ROAD_SPEED;
      _movingResource!.position = origin.position + (_direction * _progress);

      if (_progress >= 1) {
        target.receive(_movingResource!.resource);
        origin.game.removeComponent(_movingResource!);
        _movingResource = null;
        _progress = 0;
      }
    }
  }
}
