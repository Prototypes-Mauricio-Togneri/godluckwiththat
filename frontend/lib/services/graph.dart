import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/components/game/flag.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/models/route.dart';

class Graph {
  final List<Waypoint> _waypoints = [];

  void addNode(Node node) {
    _waypoints.add(Waypoint(node));
  }

  void removeNode(Node node) {
    Waypoint? found;

    for (final Waypoint waypoint in _waypoints) {
      if (waypoint.isNode(node)) {
        found = waypoint;
      }
    }

    if (found != null) {
      _waypoints.remove(found);
    } else {
      throw Exception('Waypoint for node $node not found');
    }
  }

  void addConnection(Node origin, Node target) {
    final Waypoint? waypointOrigin = _getWaypoint(origin);
    final Waypoint? waypointTarget = _getWaypoint(target);

    if ((waypointOrigin != null) && (waypointTarget != null)) {
      waypointOrigin.addConnection(waypointTarget);
    } else {
      throw Exception(
          'Waypoint does not exist. Origin: $waypointOrigin. Target: $waypointTarget');
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
    final Waypoint? from = _getWaypoint(origin);
    final Waypoint? to = _getWaypoint(target);

    if ((from != null) && (to != null)) {
      final Map<Waypoint, RouteWaypoint> allNodes = {};
      final List<RouteWaypoint> openSet = [];

      final RouteWaypoint start = RouteWaypoint.fromScores(
        waypoint: from,
        routeScore: 0,
        estimatedScore: to.distanceTo(from),
      );
      allNodes[from] = start;
      openSet.add(start);

      while (openSet.isNotEmpty) {
        final RouteWaypoint next = openSet.removeAt(0);

        if (next.current == to) {
          final List<Waypoint> list = [];
          RouteWaypoint? current = next;

          while (current != null) {
            list.add(current.current);
            current = allNodes[current.previous];
          }

          final List<Waypoint> reversed = list.reversed.toList();
          final List<Location> locations = [];

          for (int i = 1; i < reversed.length; i++) {
            locations.add(reversed[i].node.location);
          }

          return Route(locations);
        }

        for (final Waypoint waypoint in next.current.connections) {
          if (waypoint.isFlag || waypoint.isNode(target)) {
            final double newScore =
                next.routeScore + next.current.distanceTo(waypoint);
            final RouteWaypoint nextNode =
                allNodes[waypoint] ?? RouteWaypoint.fromWaypoint(waypoint);
            allNodes[waypoint] = nextNode;

            if (nextNode.routeScore > newScore) {
              nextNode.previous = next.current;
              nextNode.routeScore = newScore;
              nextNode.estimatedScore = newScore + waypoint.distanceTo(to);
              openSet.add(nextNode);
            }
          }
        }
      }
    }

    return null;
  }
}

class Waypoint {
  final Node node;
  final List<Waypoint> connections = [];

  Waypoint(this.node);

  bool isNode(Node node) => this.node == node;

  bool get isFlag => node is Flag;

  double distanceTo(Waypoint waypoint) => node.distanceTo(waypoint.node);

  void addConnection(Waypoint waypoint) {
    connections.add(waypoint);
  }
}

class RouteWaypoint implements Comparable<RouteWaypoint> {
  final Waypoint current;
  Waypoint? previous;
  double routeScore = double.infinity;
  double estimatedScore = double.infinity;

  RouteWaypoint._({
    required this.current,
    required this.previous,
    required this.routeScore,
    required this.estimatedScore,
  });

  factory RouteWaypoint.fromWaypoint(Waypoint waypoint) => RouteWaypoint._(
        current: waypoint,
        previous: null,
        routeScore: double.infinity,
        estimatedScore: double.infinity,
      );

  factory RouteWaypoint.fromScores({
    required Waypoint waypoint,
    required double routeScore,
    required double estimatedScore,
  }) =>
      RouteWaypoint._(
        current: waypoint,
        previous: null,
        routeScore: routeScore,
        estimatedScore: estimatedScore,
      );

  @override
  int compareTo(RouteWaypoint other) {
    if (estimatedScore > other.estimatedScore) {
      return 1;
    } else if (estimatedScore < other.estimatedScore) {
      return -1;
    } else {
      return 0;
    }
  }
}
