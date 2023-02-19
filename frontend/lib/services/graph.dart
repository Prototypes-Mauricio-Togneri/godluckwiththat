import 'package:tensionnode/components/base/node.dart';

class Graph {
  final List<Waypoint> waypoints = [];

  void addNode(Node node) {
    waypoints.add(Waypoint(node));
  }
}

class Waypoint {
  final Node node;

  const Waypoint(this.node);
}
