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
      patches: JsonPatches.fromJson(json['patches'] as Map<String, dynamic>),
      headquarters: JsonHeadquarters.fromJson(
          json['headquarters'] as Map<String, dynamic>),
      buildings: (json['buildings'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$NodeTypeEnumMap, k),
            (e as List<dynamic>)
                .map((e) => JsonBuilding.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$JsonMatchToJson(JsonMatch instance) => <String, dynamic>{
      'version': instance.version,
      'id': instance.id,
      'totalTimeElapsed': instance.totalTimeElapsed,
      'map': instance.map,
      'patches': instance.patches,
      'headquarters': instance.headquarters,
      'buildings':
          instance.buildings.map((k, e) => MapEntry(_$NodeTypeEnumMap[k]!, e)),
    };

const _$NodeTypeEnumMap = {
  NodeType.headquarters: 'headquarters',
  NodeType.solar_panel: 'solar_panel',
  NodeType.iron_mine: 'iron_mine',
  NodeType.copper_mine: 'copper_mine',
  NodeType.coal_mine: 'coal_mine',
  NodeType.stone_mine: 'stone_mine',
  NodeType.iron_smelter: 'iron_smelter',
  NodeType.copper_smelter: 'copper_smelter',
  NodeType.drone_factory: 'drone_factory',
};
