import 'package:tensionplanet/models/buildings/building.dart';
import 'package:tensionplanet/models/patch.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/resource_type.dart';

class Producer extends Building {
  final ResourceType resourceType;
  final Patch patch;
  double productionTime;
  double accumulatedTime = 0;

  Producer({
    required BuildingType buildingType,
    required this.resourceType,
    required this.patch,
    required this.productionTime,
    required super.village,
    required super.level,
    required super.workers,
  }) : super(
          buildingType: buildingType,
          offset: patch.location.offset,
        );

  @override
  void update(double dt) {
    accumulatedTime += dt;

    if (accumulatedTime > productionTime) {
      accumulatedTime -= productionTime;
      village.addResource(resourceType);
    }
  }
}
