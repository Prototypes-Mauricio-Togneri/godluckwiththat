// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonNode _$JsonNodeFromJson(Map<String, dynamic> json) => JsonNode(
      type: $enumDecode(_$NodeTypeEnumMap, json['type']),
      resource: $enumDecodeNullable(_$ResourceTypeEnumMap, json['resource']),
      position:
          (json['position'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$JsonNodeToJson(JsonNode instance) {
  final val = <String, dynamic>{
    'type': _$NodeTypeEnumMap[instance.type]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('resource', _$ResourceTypeEnumMap[instance.resource]);
  val['position'] = instance.position;
  return val;
}

const _$NodeTypeEnumMap = {
  NodeType.headquarters: 'headquarters',
  NodeType.mine_red: 'mine_red',
  NodeType.mine_green: 'mine_green',
  NodeType.mine_blue: 'mine_blue',
};

const _$ResourceTypeEnumMap = {
  ResourceType.red: 'red',
  ResourceType.green: 'green',
  ResourceType.blue: 'blue',
};
