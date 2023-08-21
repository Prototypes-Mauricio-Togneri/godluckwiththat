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
  BuildingType.house: 'house',
  BuildingType.warehouse: 'warehouse',
  BuildingType.farm: 'farm',
  BuildingType.woodcutter: 'woodcutter',
  BuildingType.quarry: 'quarry',
};
