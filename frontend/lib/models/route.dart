import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/models/location.dart';

class Route {
  final Locations _waypoints;

  const Route(this._waypoints);

  bool get isEmpty => _waypoints.isEmpty;

  Location? get first => isEmpty ? null : _waypoints[0];

  bool isDestination(Node node) =>
      (_waypoints.length == 1) && (_waypoints[0] == node.location);

  void pop() => _waypoints.removeAt(0);

  @override
  String toString() => _waypoints.toString();
}
