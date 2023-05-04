import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class Producer extends Building {
  final ResourceType resourceType;
  double productionTime;
  double resourcesProduced = 0;

  Producer({
    required BuildingType buildingType,
    required this.resourceType,
    required this.productionTime,
    required super.level,
    required super.workers,
  }) : super(
          buildingType: buildingType,
        );

  double get _productionPerTick => workers / productionTime;

  double get productionPerMinute => _productionPerTick * 60;

  @override
  void update(double dt) {
    resourcesProduced += dt * _productionPerTick;
    final int resources = resourcesProduced.truncate();

    if (resourcesProduced >= 1) {
      resourcesProduced -= resources;
      colony.addResource(resourceType);
    }
  }
}
