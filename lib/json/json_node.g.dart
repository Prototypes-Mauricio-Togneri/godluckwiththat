// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonNode _$JsonNodeFromJson(Map<String, dynamic> json) => JsonNode(
      type: $enumDecode(_$NodeTypeEnumMap, json['type']),
      hp: json['hp'] as num,
      resource: $enumDecodeNullable(_$ResourceTypeEnumMap, json['resource']),
      position: (json['position'] as List<dynamic>).map((e) => e as int).toList(),
      top: (json['top'] as List<dynamic>?)?.map((e) => e as int).toList(),
      bottom: (json['bottom'] as List<dynamic>?)?.map((e) => e as int).toList(),
      left: (json['left'] as List<dynamic>?)?.map((e) => e as int).toList(),
      right: (json['right'] as List<dynamic>?)?.map((e) => e as int).toList(),
    );

Map<String, dynamic> _$JsonNodeToJson(JsonNode instance) => <String, dynamic>{
      'type': _$NodeTypeEnumMap[instance.type]!,
      'hp': instance.hp,
      'resource': _$ResourceTypeEnumMap[instance.resource],
      'position': instance.position,
      'top': instance.top,
      'bottom': instance.bottom,
      'left': instance.left,
      'right': instance.right,
    };

const _$NodeTypeEnumMap = {
  NodeType.headquarters: 'headquarters',
  NodeType.intersection: 'intersection',
  NodeType.mine: 'mine',
  NodeType.power_plant: 'power_plant',
  NodeType.wall: 'wall',
  NodeType.light_turret: 'light_turret',
  NodeType.heavy_turret: 'heavy_turret',
  NodeType.long_range_turret: 'long_range_turret',
  NodeType.ion_turret: 'ion_turret',
  NodeType.gauss_turret: 'gauss_turret',
  NodeType.plasma_turret: 'plasma_turret',
  NodeType.pulse_turret: 'pulse_turret',
};

const _$ResourceTypeEnumMap = {
  ResourceType.resource1: 'resource1',
  ResourceType.resource2: 'resource2',
  ResourceType.resource3: 'resource3',
};
