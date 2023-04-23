// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_colony.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonColony _$JsonColonyFromJson(Map<String, dynamic> json) => JsonColony(
      inventory: (json['inventory'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ResourceTypeEnumMap, k), e as int),
      ),
      freeVillagers: json['freeVillagers'] as int,
      zones: (json['zones'] as List<dynamic>)
          .map((e) => JsonZone.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonColonyToJson(JsonColony instance) =>
    <String, dynamic>{
      'inventory': instance.inventory
          .map((k, e) => MapEntry(_$ResourceTypeEnumMap[k]!, e)),
      'freeVillagers': instance.freeVillagers,
      'zones': instance.zones,
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
