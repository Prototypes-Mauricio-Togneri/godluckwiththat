// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_colony.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonColony _$JsonColonyFromJson(Map<String, dynamic> json) => JsonColony(
      owner: json['owner'] as String,
      inventory: (json['inventory'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ResourceTypeEnumMap, k), e as int),
      ),
      freeVillagers: json['freeVillagers'] as int,
      color: json['color'] as String,
    );

Map<String, dynamic> _$JsonColonyToJson(JsonColony instance) =>
    <String, dynamic>{
      'owner': instance.owner,
      'inventory': instance.inventory
          .map((k, e) => MapEntry(_$ResourceTypeEnumMap[k]!, e)),
      'freeVillagers': instance.freeVillagers,
      'color': instance.color,
    };

const _$ResourceTypeEnumMap = {
  ResourceType.food: 'food',
  ResourceType.wood: 'wood',
  ResourceType.stone: 'stone',
  ResourceType.villager: 'villager',
};
