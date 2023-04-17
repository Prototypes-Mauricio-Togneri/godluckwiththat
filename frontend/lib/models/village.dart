import 'package:tensionplanet/components/buildings/building.dart';

class Village {
  final String name;
  final List<Building> buildings;

  Village({
    required this.name,
    required this.buildings,
  });

  void update(double dt) {
    for (final Building building in buildings) {
      building.update(dt);
    }
  }
}
