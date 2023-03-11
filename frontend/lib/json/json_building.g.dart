// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_building.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonBuilding _$JsonBuildingFromJson(Map<String, dynamic> json) => JsonBuilding(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      inventory: (json['inventory'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ResourceTypeEnumMap, k), e as int),
      ),
    );

Map<String, dynamic> _$JsonBuildingToJson(JsonBuilding instance) =>
    <String, dynamic>{
      'location': instance.location,
      'inventory': instance.inventory
          .map((k, e) => MapEntry(_$ResourceTypeEnumMap[k]!, e)),
    };

const _$ResourceTypeEnumMap = {
  ResourceType.energy: 'energy',
  ResourceType.iron_ore: 'iron_ore',
  ResourceType.copper_ore: 'copper_ore',
  ResourceType.coal_ore: 'coal_ore',
  ResourceType.oil: 'oil',
  ResourceType.stone_ore: 'stone_ore',
  ResourceType.iron_block: 'iron_block',
  ResourceType.copper_block: 'copper_block',
  ResourceType.steel: 'steel',
  ResourceType.plastic: 'plastic',
  ResourceType.concrete: 'concrete',
  ResourceType.gear: 'gear',
  ResourceType.circuit: 'circuit',
  ResourceType.drone: 'drone',
};
