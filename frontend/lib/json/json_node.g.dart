// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonNode _$JsonNodeFromJson(Map<String, dynamic> json) => JsonNode(
      type: $enumDecode(_$NodeTypeEnumMap, json['type']),
      location:
          (json['location'] as List<dynamic>).map((e) => e as int).toList(),
      resources:
          JsonResources.fromJson(json['resources'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JsonNodeToJson(JsonNode instance) => <String, dynamic>{
      'type': _$NodeTypeEnumMap[instance.type]!,
      'location': instance.location,
      'resources': instance.resources,
    };

const _$NodeTypeEnumMap = {
  NodeType.headquarters: 'headquarters',
  NodeType.woodcutter: 'woodcutter',
  NodeType.quarry: 'quarry',
  NodeType.sawmill: 'sawmill',
};
