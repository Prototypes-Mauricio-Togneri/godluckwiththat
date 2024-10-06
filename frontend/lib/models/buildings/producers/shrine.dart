import 'package:godluckwiththat/app/constants.dart';
import 'package:godluckwiththat/models/buildings/producers/producer.dart';
import 'package:godluckwiththat/types/building_type.dart';
import 'package:godluckwiththat/types/resource_type.dart';

class Shrine extends Producer {
  Shrine({
    required super.colony,
    required super.level,
    required super.workers,
  }) : super(
          buildingType: BuildingType.shrine,
          resourceType: ResourceType.faith,
          productionRate: Constants.SHRINE_PRODUCTION_RATE,
        );
}
