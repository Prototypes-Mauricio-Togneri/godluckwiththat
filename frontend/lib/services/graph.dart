import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/route.dart';

class Graph {
  final List<Waypoint> _waypoints = [];

  void addNode(Node node) {
    _waypoints.add(Waypoint(node));
  }

  void addConnection(Node origin, Node target) {
    for (final Waypoint waypoint in _waypoints) {
      if (waypoint.isNode(origin)) {
        waypoint.addConnection(target);
      }
    }
  }

  Route? search(Node origin, Node target) {
    // TODO(momo): implement
    return const Route([]);
  }
}

class Waypoint {
  final Node node;
  final List<Node> connections = [];

  Waypoint(this.node);

  bool isNode(Node node) => this.node == node;

  void addConnection(Node node) {
    connections.add(node);
  }
}
