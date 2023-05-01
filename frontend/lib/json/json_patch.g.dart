// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_patch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonPatch _$JsonPatchFromJson(Map<String, dynamic> json) => JsonPatch(
      patchType: $enumDecode(_$PatchTypeEnumMap, json['patch_type']),
      location: $enumDecode(_$ZoneLocationEnumMap, json['location']),
      buildingType:
          $enumDecodeNullable(_$BuildingTypeEnumMap, json['building_type']),
      level: json['level'] as int?,
      workers: json['workers'] as int?,
    );

Map<String, dynamic> _$JsonPatchToJson(JsonPatch instance) {
  final val = <String, dynamic>{
    'patch_type': _$PatchTypeEnumMap[instance.patchType]!,
    'location': _$ZoneLocationEnumMap[instance.location]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('building_type', _$BuildingTypeEnumMap[instance.buildingType]);
  writeNotNull('level', instance.level);
  writeNotNull('workers', instance.workers);
  return val;
}

const _$PatchTypeEnumMap = {
  PatchType.empty: 'empty',
  PatchType.crop_field: 'crop_field',
  PatchType.forest: 'forest',
  PatchType.stone_deposit: 'stone_deposit',
};

const _$ZoneLocationEnumMap = {
  ZoneLocation.north: 'north',
  ZoneLocation.south: 'south',
  ZoneLocation.west: 'west',
  ZoneLocation.east: 'east',
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
