import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/types/resource_type.dart';

class Road {
  final Node origin;
  final Node target;
  final num distance;
  ResourceType? _resource;
  num _progress = 0;

  Road(this.origin, this.target)
      : distance = origin.location.distanceTo(target.location);

  bool get isAvailable => _resource == null;

  void send(ResourceType resource) {
    _resource = resource;
    _progress = 0;
  }

  void update(double dt) {
    if (_resource != null) {
      _progress += dt / 3;

      if (_progress >= 1) {
        target.receive(_resource!);
        _resource = null;
        _progress = 0;
      }
    }
  }
}
