import 'package:gatewayguardians/models/buildings/producers/producer.dart';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/resource_type.dart';

class Field extends Producer {
  Field({
    required super.level,
    required super.villagers,
  }) : super(
          buildingType: BuildingType.field,
          resourceType: ResourceType.food,
        );
}
