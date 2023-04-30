// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_patch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonPatch _$JsonPatchFromJson(Map<String, dynamic> json) => JsonPatch(
      type: $enumDecode(_$PatchTypeEnumMap, json['type']),
      location: $enumDecode(_$ZoneLocationEnumMap, json['location']),
    );

Map<String, dynamic> _$JsonPatchToJson(JsonPatch instance) => <String, dynamic>{
      'type': _$PatchTypeEnumMap[instance.type]!,
      'location': _$ZoneLocationEnumMap[instance.location]!,
    };

const _$PatchTypeEnumMap = {
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
