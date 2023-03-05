// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_headquarters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonHeadquarters _$JsonHeadquartersFromJson(Map<String, dynamic> json) =>
    JsonHeadquarters(
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      inventory: (json['inventory'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ResourceTypeEnumMap, k), e as int),
      ),
    );

Map<String, dynamic> _$JsonHeadquartersToJson(JsonHeadquarters instance) =>
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
  ResourceType.stone_ore: 'stone_ore',
  ResourceType.iron_block: 'iron_block',
  ResourceType.copper_block: 'copper_block',
  ResourceType.steel: 'steel',
  ResourceType.concrete: 'concrete',
  ResourceType.drone_basic: 'drone_basic',
};
