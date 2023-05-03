// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_building.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonBuilding _$JsonBuildingFromJson(Map<String, dynamic> json) => JsonBuilding(
      buildingType: $enumDecode(_$BuildingTypeEnumMap, json['building_type']),
      level: json['level'] as int,
      workers: json['workers'] as int,
    );

Map<String, dynamic> _$JsonBuildingToJson(JsonBuilding instance) =>
    <String, dynamic>{
      'building_type': _$BuildingTypeEnumMap[instance.buildingType]!,
      'level': instance.level,
      'workers': instance.workers,
    };

const _$BuildingTypeEnumMap = {
  BuildingType.headquarters: 'headquarters',
  BuildingType.house: 'house',
  BuildingType.warehouse: 'warehouse',
  BuildingType.farm: 'farm',
  BuildingType.woodcutter: 'woodcutter',
  BuildingType.quarry: 'quarry',
  BuildingType.copper_mine: 'copper_mine',
  BuildingType.iron_mine: 'iron_mine',
  BuildingType.gold_mine: 'gold_mine',
  BuildingType.barracks: 'barracks',
  BuildingType.archery: 'archery',
  BuildingType.cavalry: 'cavalry',
  BuildingType.workshop: 'workshop',
  BuildingType.fortress: 'fortress',
};
