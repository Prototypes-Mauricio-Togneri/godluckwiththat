// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonMatch _$JsonMatchFromJson(Map<String, dynamic> json) => JsonMatch(
      version: json['version'] as int,
      id: json['id'] as String,
      totalTimeElapsed: json['totalTimeElapsed'] as num,
      map: JsonMap.fromJson(json['map'] as Map<String, dynamic>),
      inventory: (json['inventory'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ResourceTypeEnumMap, k), e as int),
      ),
      patches: JsonPatches.fromJson(json['patches'] as Map<String, dynamic>),
      buildings:
          JsonBuildings.fromJson(json['buildings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonMatchToJson(JsonMatch instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'totalTimeElapsed': instance.totalTimeElapsed,
      'map': instance.map,
      'inventory': instance.inventory
          .map((k, e) => MapEntry(_$ResourceTypeEnumMap[k]!, e)),
      'patches': instance.patches,
      'buildings': instance.buildings,
    };

const _$ResourceTypeEnumMap = {
  ResourceType.energy: 'energy',
  ResourceType.iron_ore: 'iron_ore',
  ResourceType.copper_ore: 'copper_ore',
  ResourceType.coal_ore: 'coal_ore',
  ResourceType.stone_ore: 'stone_ore',
  ResourceType.copper_block: 'copper_block',
};
