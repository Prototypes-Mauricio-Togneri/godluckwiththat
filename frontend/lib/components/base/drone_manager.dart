import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/drone.dart';
import 'package:tensionnode/types/drone_type.dart';

mixin NodeManager {
  final List<Drone> _constructionDrones = [];
  final List<Drone> _logisticDrones = [];
  final List<Node> _connections = [];

  bool get hasConstructionDrones => _constructionDrones.isNotEmpty;

  bool get hasLogisticDrones => _logisticDrones.isNotEmpty;

  bool get hasConnections => _connections.isNotEmpty;

  Drone get getConstructionDrone => _constructionDrones.removeAt(0);

  Drone get getLogisticDrone => _logisticDrones.removeAt(0);

  int get availableConstructionDrones => _constructionDrones.length;

  int get availableLogisticDrones => _logisticDrones.length;

  Node get getConnection => _connections[0];

  List<Node> get connections => _connections;

  void initialize({
    required List<Drone> constructionDrones,
    required List<Drone> logisticDrones,
    required List<Node> connections,
  }) {
    _constructionDrones.addAll(constructionDrones);
    _logisticDrones.addAll(logisticDrones);
    _connections.addAll(connections);
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
}
