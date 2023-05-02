import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class Producer extends Building {
  final ResourceType resourceType;
  double productionTime;
  double accumulatedTime = 0;

  Producer({
    required BuildingType buildingType,
    required this.resourceType,
    required this.productionTime,
    required super.level,
    required super.workers,
  }) : super(
          buildingType: buildingType,
        );

  // resources per minute
  double get productionRate => (workers > 0) ? (productionTime / workers) : 0;

  @override
  void update(double dt) {
    accumulatedTime += dt * workers;

    if (accumulatedTime > productionTime) {
      accumulatedTime -= productionTime;
      colony.addResource(resourceType);
    }
  }
}
