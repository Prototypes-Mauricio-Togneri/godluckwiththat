import 'package:tensionplanet/components/buildings/building.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Producer extends Building {
  final ResourceType resourceType;
  double productionTime;
  double accumulatedTime = 0;

  Producer({
    required BuildingType buildingType,
    required this.resourceType,
    required this.productionTime,
    required super.level,
  }) : super(buildingType: buildingType);

  @override
  void update(double dt) {
    super.update(dt);

    accumulatedTime += dt;

    if (accumulatedTime > productionTime) {
      accumulatedTime -= productionTime;
      gameRef.state.addResource(resourceType);
    }
  }
}
