import 'package:tensionnode/models/location.dart';

class Connections {
  Location? north;
  Location? east;
  Location? south;
  Location? west;

  Connections({
    this.north,
    this.east,
    this.south,
    this.west,
  });

  bool get isNotEmpty =>
      (north != null) || (east != null) || (south != null) || (west != null);

  void connect(Connections roads) {
    north = roads.north;
    east = roads.east;
    south = roads.south;
    west = roads.west;
  }
}
