// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_building.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonBuilding _$JsonBuildingFromJson(Map<String, dynamic> json) => JsonBuilding(
      type: $enumDecode(_$BuildingTypeEnumMap, json['type']),
      level: json['level'] as int,
      workers: json['workers'] as int,
      location: $enumDecodeNullable(_$PatchLocationEnumMap, json['location']),
    );

Map<String, dynamic> _$JsonBuildingToJson(JsonBuilding instance) {
  final val = <String, dynamic>{
    'type': _$BuildingTypeEnumMap[instance.type]!,
    'level': instance.level,
    'workers': instance.workers,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('location', _$PatchLocationEnumMap[instance.location]);
  return val;
}

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

const _$PatchLocationEnumMap = {
  PatchLocation.north: 'north',
  PatchLocation.south: 'south',
  PatchLocation.west: 'west',
  PatchLocation.east: 'east',
};
