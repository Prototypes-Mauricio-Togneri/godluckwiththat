import 'package:gatewayguardians/models/buildings/producer.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class CopperMine extends Producer {
  CopperMine({
    required super.colony,
    required super.zone,
    required super.level,
    required super.workers,
    required super.productionTime,
  }) : super(
          buildingType: BuildingType.copper_mine,
          resourceType: ResourceType.copper,
        );
}
