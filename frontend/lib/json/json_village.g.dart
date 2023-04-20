// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_village.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonVillage _$JsonVillageFromJson(Map<String, dynamic> json) => JsonVillage(
      name: json['name'] as String,
      inventory: (json['inventory'] as Map<String, dynamic>).map(
        (k, e) => MapEntry($enumDecode(_$ResourceTypeEnumMap, k), e as int),
      ),
      freeVillagers: json['freeVillagers'] as int,
      patches: (json['patches'] as List<dynamic>)
          .map((e) => JsonPatch.fromJson(e as Map<String, dynamic>))
          .toList(),
      buildings: (json['buildings'] as List<dynamic>)
          .map((e) => JsonBuilding.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonVillageToJson(JsonVillage instance) =>
    <String, dynamic>{
      'name': instance.name,
      'inventory': instance.inventory
          .map((k, e) => MapEntry(_$ResourceTypeEnumMap[k]!, e)),
      'freeVillagers': instance.freeVillagers,
      'patches': instance.patches,
      'buildings': instance.buildings,
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
