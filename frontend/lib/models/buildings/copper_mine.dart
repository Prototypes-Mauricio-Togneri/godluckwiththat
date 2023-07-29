import 'package:gatewayguardians/models/buildings/producer.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class CopperMine extends Producer {
  CopperMine({
    required super.level,
    required super.villagers,
  }) : super(
          buildingType: BuildingType.copper_mine,
          resourceType: ResourceType.copper,
        );
}
