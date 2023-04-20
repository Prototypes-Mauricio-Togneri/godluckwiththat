// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_patch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonPatch _$JsonPatchFromJson(Map<String, dynamic> json) => JsonPatch(
      type: $enumDecode(_$ResourceTypeEnumMap, json['type']),
      location: $enumDecode(_$PatchLocationEnumMap, json['location']),
    );

Map<String, dynamic> _$JsonPatchToJson(JsonPatch instance) => <String, dynamic>{
      'type': _$ResourceTypeEnumMap[instance.type]!,
      'location': _$PatchLocationEnumMap[instance.location]!,
    };

const _$ResourceTypeEnumMap = {
  ResourceType.food: 'food',
  ResourceType.wood: 'wood',
  ResourceType.stone: 'stone',
  ResourceType.copper: 'copper',
  ResourceType.iron: 'iron',
  ResourceType.gold: 'gold',
  ResourceType.villager: 'villager',
};

const _$PatchLocationEnumMap = {
  PatchLocation.north: 'north',
  PatchLocation.south: 'south',
  PatchLocation.west: 'west',
  PatchLocation.east: 'east',
};
