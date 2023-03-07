import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/drone.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/resource_type.dart';

mixin DroneManager {
  Inventory _inventory = Inventory({});
  final List<Node> _droneConnections = [];
  final List<Node> _droneTransfers = [];
  int connectionIndex = 0;

  bool get hasDrones => _inventory.get(ResourceType.drone) > 0;

  bool get hasDroneConnections => _droneConnections.isNotEmpty;

  bool get hasDroneTransfers => _droneTransfers.isNotEmpty;

  int get availableDrones => _inventory.get(ResourceType.drone);

  Node get getAvailableConnection {
    connectionIndex++;
    final int index = connectionIndex % _droneConnections.length;

    return _droneConnections[index];
  }

  List<Node> get droneConnections => _droneConnections;

  List<Node> get droneTransfers => _droneTransfers;

  void initialize({
    required Inventory inventory,
    required List<Node> droneConnections,
    required List<Node> droneTransfers,
  }) {
    _inventory = inventory;
    _droneConnections.addAll(droneConnections);
    _droneTransfers.addAll(droneTransfers);
  }

  void addDrone(Drone drone) {
    _inventory.addResource(Resource.one(ResourceType.drone));
  }

  Drone getDrone() {
    _inventory.removeResource(Resource.one(ResourceType.drone));

    return Drone();
  }

  bool hasDroneConnection(Node to) => _droneConnections.contains(to);

  void addDroneConnection(Node to) {
    if (!hasDroneConnection(to)) {
      _droneConnections.add(to);
    }
  }

  void removeDroneConnection(Node to) => _droneConnections.remove(to);

  void addDroneTransfer(Node to) {
    if (!_droneTransfers.contains(to)) {
      _droneTransfers.add(to);
    }
  }

  void removeDroneTransfer(Node to) => _droneTransfers.remove(to);
}
