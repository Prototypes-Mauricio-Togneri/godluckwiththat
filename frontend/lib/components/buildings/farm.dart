import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Farm extends Building {
  double accumulatedTime = 0;
  double productionTime = 3;

  Farm() : super(buildingType: BuildingType.farm);

  @override
  void update(double dt) {
    super.update(dt);

    accumulatedTime += dt;

    if (accumulatedTime > productionTime) {
      accumulatedTime -= productionTime;
      gameRef.state.addResource(ResourceType.food);
    }
  }
}
