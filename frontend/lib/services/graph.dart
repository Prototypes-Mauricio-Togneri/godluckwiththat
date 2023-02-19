import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/route.dart';

class Graph {
  final List<Waypoint> _waypoints = [];

  void addNode(Node node) {
    _waypoints.add(Waypoint(node));
  }

  void addConnection(Node origin, Node target) {
    final Waypoint? waypointOrigin = _getWaypoint(origin);
    final Waypoint? waypointTarget = _getWaypoint(target);

    if (waypointTarget != null) {
      waypointOrigin?.addConnection(waypointTarget);
    }
  }

  Waypoint? _getWaypoint(Node node) {
    for (final Waypoint waypoint in _waypoints) {
      if (waypoint.isNode(node)) {
        return waypoint;
      }
    }

    return null;
  }

  Route? search(Node origin, Node target) {
    final List<Location> locations = [];
    final Waypoint? start = _getWaypoint(origin);

    if (start != null) {
      final List<Waypoint> queue = [start];
      Waypoint current = start; //queue.removeAt(0);

      //while (current.node != target) {
      while (queue.isNotEmpty) {
        current = queue.removeAt(0);
        current.visited = true;
        print('Exploring: ${current.node.runtimeType}');

        for (final Waypoint waypoint in current.connections) {
          if (!waypoint.visited) {
            queue.add(waypoint);
            waypoint.visited = true;
          }
        }
      }
    }

    // TODO(momo): clean up waypoints

    return locations.isNotEmpty ? Route(locations) : null;
  }
}

class Waypoint {
  final Node node;
  final List<Waypoint> connections = [];
  bool visited = false;

  Waypoint(this.node);

  bool isNode(Node node) => this.node == node;

  void addConnection(Waypoint waypoint) {
    connections.add(waypoint);
  }
}

class RouteNode implements Comparable<RouteNode> {
  final Waypoint current;
  Waypoint? previous;
  double routeScore = double.infinity;
  double estimatedScore = double.infinity;

  RouteNode._(
      {required this.current,
      required this.previous,
      required this.routeScore,
      required this.estimatedScore});

  factory RouteNode.f1(Waypoint waypoint) => RouteNode._(
        current: waypoint,
        previous: null,
        routeScore: double.infinity,
        estimatedScore: double.infinity,
      );

  factory RouteNode.f2(Waypoint waypoint, double score) => RouteNode._(
        current: waypoint,
        previous: null,
        routeScore: double.infinity,
        estimatedScore: score,
      );

  @override
  int compareTo(RouteNode other) {
    if (estimatedScore > other.estimatedScore) {
      return 1;
    } else if (estimatedScore < other.estimatedScore) {
      return -1;
    } else {
      return 0;
    }
  }
}
