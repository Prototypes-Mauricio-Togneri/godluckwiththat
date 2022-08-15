// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonNode _$JsonNodeFromJson(Map<String, dynamic> json) => JsonNode(
      type: $enumDecode(_$NodeTypeEnumMap, json['type']),
      position: JsonPosition.fromJson(json['position'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonNodeToJson(JsonNode instance) => <String, dynamic>{
      'type': _$NodeTypeEnumMap[instance.type]!,
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
