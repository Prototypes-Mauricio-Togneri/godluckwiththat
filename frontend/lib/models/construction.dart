import 'package:tensionplanet/game/game_state.dart';
import 'package:tensionplanet/models/village.dart';
import 'package:tensionplanet/types/building_type.dart';

class Construction {
  final GameState state;
  final Village village;
  final BuildingType buildingType;
  final int toLevel;
  double remainingTime = 0;

  Construction({
    required this.state,
    required this.village,
    required this.buildingType,
    required this.toLevel,
  }) {
    remainingTime = buildingType.constructionTime(toLevel);
  }

  void update(double dt) {
    remainingTime -= dt;

    if (remainingTime < 0) {
      state.onConstructionCompleted(this);
    }
  }
}
