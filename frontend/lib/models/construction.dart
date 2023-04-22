import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/models/zone.dart';
import 'package:tensionplanet/types/building_type.dart';

class Construction {
  final Zone zone;
  final BuildingType buildingType;
  final int toLevel;
  double remainingTime = 0;

  Construction({
    required this.zone,
    required this.buildingType,
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
