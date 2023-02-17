import 'package:flame/game.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/routed_resource.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/types/resource_type.dart';

class Road {
  final Node origin;
  final Node target;
  final num distance;

  Vector2 _direction = Vector2.zero();
  double _progress = 0;
  RoutedResource? _routedResource;

  Road(this.origin, this.target)
      : distance = origin.location.distanceTo(target.location);

  bool get isAvailable => _routedResource == null;

  JsonLocation get json => target.location.json;

  void send(ResourceType resource) {
    _progress = 0;
    _routedResource = RoutedResource(type: resource);
    _direction = target.position - origin.position;
    origin.game.addToResourcesLayer(_routedResource!);
  }

  void update(double dt) {
    if (_routedResource != null) {
      _progress += dt / 3;
      _routedResource!.position = origin.position + (_direction * _progress);

      if (_progress >= 1) {
        target.receive(_routedResource!.type);
        origin.game.removeFromResourcesLayer(_routedResource!);
        _routedResource = null;
        _progress = 0;
      }
    }
  }
}
