import 'package:tensionnode/json/json_connections.dart';
import 'package:tensionnode/models/road.dart';

class Roads {
  Road? north;
  Road? east;
  Road? south;
  Road? west;

  Roads({
    this.north,
    this.east,
    this.south,
    this.west,
  });

  void connect(Roads roads) {
    north = roads.north;
    east = roads.east;
    south = roads.south;
    west = roads.west;
  }

  JsonConnections get json => JsonConnections(
        north: north?.json,
        east: east?.json,
        south: south?.json,
        west: west?.json,
      );
}
