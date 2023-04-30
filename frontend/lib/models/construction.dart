import 'package:gatewayguardians/game/game_state.dart';
import 'package:gatewayguardians/models/zone.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/zone_location.dart';

class Construction {
  final Zone zone;
  final BuildingType buildingType;
  final ZoneLocation location;
  final int toLevel;
  double remainingTime = 0;

  Construction({
    required this.zone,
    required this.buildingType,
    required this.location,
    required this.toLevel,
  }) {
    remainingTime = buildingType.constructionTime(toLevel);
  }

  void update(double dt) {
    remainingTime -= dt;

    if (remainingTime < 0) {
      GameState.instance.onConstructionCompleted(this);
    }
  }
}
