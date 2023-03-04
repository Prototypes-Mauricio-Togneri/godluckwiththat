import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/drone_type.dart';

class Drone {
  final DroneType type;
  Resource resource;

  Drone({
    required this.type,
    required this.resource,
  });

  void removeResource() {
    resource = Resource(resource.type, 0);
  }
}
