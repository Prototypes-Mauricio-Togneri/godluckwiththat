import 'package:tensionnode/models/location.dart';

class Route {
  final List<Location> _waypoints;

  const Route(this._waypoints);

  bool get isEmpty => _waypoints.isEmpty;

  Location? get first => isEmpty ? null : _waypoints[0];
}
