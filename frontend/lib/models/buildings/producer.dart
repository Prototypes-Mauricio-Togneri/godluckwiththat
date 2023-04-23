import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/patch.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

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
    required super.colony,
    required super.zone,
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
      colony.addResource(resourceType);
    }
  }
}
