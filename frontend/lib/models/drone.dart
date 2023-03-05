import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/drone_type.dart';

class Drone {
  final DroneType type;
  Resource? _resource;

  Drone._(this.type);

  factory Drone.basic() => Drone._(DroneType.basic);

  factory Drone.intermediate() => Drone._(DroneType.intermediate);

  factory Drone.advance() => Drone._(DroneType.advance);

  bool get hasResource => _resource != null;

  void load(Resource resource) {
    _resource = resource;
  }

  Resource? unload() {
    final Resource? result = _resource;
    _resource = null;

    return result;
  }
}
