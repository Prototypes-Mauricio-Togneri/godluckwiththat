import 'package:flame/game.dart';
import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/routed_resource.dart';
import 'package:tensionnode/types/resource_type.dart';

class Road {
  final Node origin;
  final Node target;
  final num distance;
  double _progress = 0;
  RoutedResource? _routedResource;

  Road(this.origin, this.target)
      : distance = origin.location.distanceTo(target.location);

  bool get isAvailable => _routedResource == null;

  void send(ResourceType resource) {
    _progress = 0;

    _routedResource = RoutedResource(type: resource);
    origin.game.addToResourcesLayer(_routedResource!);
  }

  void update(double dt) {
    if (_routedResource != null) {
      _progress += dt / 3;
      final Vector2 direction = target.position - origin.position;
      _routedResource!.position = origin.position + (direction * _progress);

      if (_progress >= 1) {
        target.receive(_routedResource!.type);
        origin.game.removeFromResourcesLayer(_routedResource!);
        _routedResource = null;
        _progress = 0;
      }
    }
  }
}
