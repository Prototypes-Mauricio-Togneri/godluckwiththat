import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/drone_type.dart';

class Drone {
  final DroneType type;
  Resource? _resource;

  Drone({
    required this.type,
  });

  factory Drone.construction() => Drone(type: DroneType.construction);

  factory Drone.logistic() => Drone(type: DroneType.logistic);

  bool get hasResource => _resource != null;

  bool get isConstruction => type == DroneType.construction;

  bool get isLogistic => type == DroneType.logistic;

  void load(Resource resource) {
    _resource = resource;
  }

  Resource? unload() {
    final Resource? result = _resource;
    _resource = null;

    return result;
  }
}
