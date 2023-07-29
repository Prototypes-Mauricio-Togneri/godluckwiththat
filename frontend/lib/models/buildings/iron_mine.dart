import 'package:gatewayguardians/models/buildings/producer.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class IronMine extends Producer {
  IronMine({
    required super.level,
    required super.villagers,
  }) : super(
          buildingType: BuildingType.iron_mine,
          resourceType: ResourceType.iron,
        );
}
