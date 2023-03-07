import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/drone.dart';

mixin DroneManager {
  final List<Drone> _drones = [];
  final List<Node> _droneConnections = [];
  final List<Node> _droneTransfers = [];
  int connectionIndex = 0;

  bool get hasDrones => _drones.isNotEmpty;

  bool get hasDroneConnections => _droneConnections.isNotEmpty;

  bool get hasDroneTransfers => _droneTransfers.isNotEmpty;

  int get availableDrones => _drones.length;

  Node get getAvailableConnection {
    connectionIndex++;
    final int index = connectionIndex % _droneConnections.length;

    return _droneConnections[index];
  }

  List<Node> get droneConnections => _droneConnections;

  List<Node> get droneTransfers => _droneTransfers;

  Drone getDrone() => _drones.removeAt(0);

  void initialize({
    required List<Drone> drones,
    required List<Node> droneConnections,
    required List<Node> droneTransfers,
  }) {
    _drones.addAll(drones);
    _droneConnections.addAll(droneConnections);
    _droneTransfers.addAll(droneTransfers);
  }

  void addDrone(Drone drone) {
    _drones.add(drone);
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
