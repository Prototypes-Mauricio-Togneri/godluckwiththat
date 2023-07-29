import 'package:gatewayguardians/models/buildings/producer.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class Quarry extends Producer {
  Quarry({
    required super.level,
    required super.villagers,
  }) : super(
          buildingType: BuildingType.quarry,
          resourceType: ResourceType.stone,
        );
}
