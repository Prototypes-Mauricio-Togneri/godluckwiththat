// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_patch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonPatch _$JsonPatchFromJson(Map<String, dynamic> json) => JsonPatch(
      patchType: $enumDecode(_$PatchTypeEnumMap, json['patch_type']),
      location: $enumDecode(_$ZoneLocationEnumMap, json['location']),
      building: json['building'] == null
          ? null
          : JsonBuilding.fromJson(json['building'] as Map<String, dynamic>),
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

  writeNotNull('building', instance.building);
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
