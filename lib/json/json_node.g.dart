// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonNode _$JsonNodeFromJson(Map<String, dynamic> json) => JsonNode(
      type: $enumDecode(_$NodeTypeEnumMap, json['type']),
      resource: $enumDecodeNullable(_$ResourceTypeEnumMap, json['resource']),
      position: (json['position'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$JsonNodeToJson(JsonNode instance) => <String, dynamic>{
      'type': _$NodeTypeEnumMap[instance.type]!,
      'resource': _$ResourceTypeEnumMap[instance.resource],
      'position': instance.position,
    };

const _$NodeTypeEnumMap = {
  NodeType.headquarters: 'headquarters',
  NodeType.mine: 'mine',
  NodeType.power_plant: 'power_plant',
  NodeType.tower: 'tower',
  NodeType.wall: 'wall',
  NodeType.intersection: 'intersection',
};

const _$ResourceTypeEnumMap = {
  ResourceType.resource1: 'resource1',
  ResourceType.resource2: 'resource2',
  ResourceType.resource3: 'resource3',
};
