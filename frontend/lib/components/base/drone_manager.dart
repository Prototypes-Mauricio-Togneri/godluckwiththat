import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/drone.dart';
import 'package:tensionnode/models/inventory.dart';
import 'package:tensionnode/models/resource.dart';
import 'package:tensionnode/types/resource_type.dart';

mixin DroneManager {
  Inventory _inventory = Inventory({});
  final List<Node> _droneConnections = [];
  final List<Node> _droneTransfers = [];
  int _connectionIndex = 0;
  int dronesAssigned = 0;

  bool get hasDrones => _inventory.get(ResourceType.drone) > 0;

  bool get hasDroneConnections => _droneConnections.isNotEmpty;

  bool get hasDroneTransfers => _droneTransfers.isNotEmpty;

  int get availableDrones => _inventory.get(ResourceType.drone);

  Node get getAvailableConnection {
    _connectionIndex++;
    final int index = _connectionIndex % _droneConnections.length;

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
    dronesAssigned = _inventory.get(ResourceType.drone);
  }

  void addDrone({
    required Node receiver,
    required Drone drone,
  }) {
    _inventory.addResource(Resource.one(ResourceType.drone));

    if (!drone.isHome(receiver)) {
      dronesAssigned++;
    }
  }

  Drone? getDrone({
    required Node home,
    required bool roundtrip,
  }) {
    final Resource resource = Resource.one(ResourceType.drone);

    if (_inventory.hasResource(resource)) {
      _inventory.removeResource(resource);

      if (!roundtrip) {
        dronesAssigned--;
      }

      return Drone(home);
    } else {
      return null;
    }
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
