import 'package:gatewayguardians/models/buildings/building.dart';
import 'package:gatewayguardians/models/resource.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class Producer extends Building {
  final ResourceType resourceType;

  Producer({
    required BuildingType buildingType,
    required this.resourceType,
    required super.level,
    required super.villagers,
  }) : super(
          buildingType: buildingType,
        );

  Resource produce() =>
      Resource(resourceType, buildingType.productionRate * villagers);
}
