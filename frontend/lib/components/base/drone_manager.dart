import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/drone.dart';
import 'package:tensionnode/types/drone_type.dart';

mixin NodeManager {
  final List<Drone> _constructionDrones = [];
  final List<Drone> _logisticDrones = [];
  final List<Node> _droneConnections = [];
  final List<Node> _droneTransfers = [];
  int connectionIndex = 0;

  bool get hasConstructionDrones => _constructionDrones.isNotEmpty;

  bool get hasLogisticDrones => _logisticDrones.isNotEmpty;

  bool get hasDroneConnections => _droneConnections.isNotEmpty;

  bool get hasDroneTransfers => _droneTransfers.isNotEmpty;

  int get availableConstructionDrones => _constructionDrones.length;

  int get availableLogisticDrones => _logisticDrones.length;

  Node get getAvailableConnection {
    connectionIndex++;
    final int index = connectionIndex % _droneConnections.length;

    return _droneConnections[index];
  }

  List<Node> get droneConnections => _droneConnections;

  List<Node> get droneTransfers => _droneTransfers;

  Drone getConstructionDrone() => _constructionDrones.removeAt(0);

  Drone getLogisticDrone() => _logisticDrones.removeAt(0);

  void initialize({
    required List<Drone> constructionDrones,
    required List<Drone> logisticDrones,
    required List<Node> droneConnections,
    required List<Node> droneTransfers,
  }) {
    _constructionDrones.addAll(constructionDrones);
    _logisticDrones.addAll(logisticDrones);
    _droneConnections.addAll(droneConnections);
    _droneTransfers.addAll(droneTransfers);
  }

  void addDrone(Drone drone) {
    switch (drone.type) {
      case DroneType.construction:
        _constructionDrones.add(drone);
        break;
      case DroneType.logistic:
        _logisticDrones.add(drone);
        break;
    }
  }

  void addDroneConnection(Node to) {
    if (!_droneConnections.contains(to)) {
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
