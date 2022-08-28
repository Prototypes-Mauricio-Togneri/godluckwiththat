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

Map<String, dynamic> _$JsonNodeToJson(JsonNode instance) {
  final val = <String, dynamic>{
    'type': _$NodeTypeEnumMap[instance.type]!,
    'hp': instance.hp,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('resource', _$ResourceTypeEnumMap[instance.resource]);
  val['position'] = instance.position;
  writeNotNull('top', instance.top);
  writeNotNull('bottom', instance.bottom);
  writeNotNull('left', instance.left);
  writeNotNull('right', instance.right);
  return val;
}

const _$NodeTypeEnumMap = {
  NodeType.headquarters: 'headquarters',
  NodeType.intersection: 'intersection',
  NodeType.mine: 'mine',
  NodeType.power_plant: 'power_plant',
  NodeType.wall: 'wall',
  NodeType.light_turret: 'light_turret',
  NodeType.heavy_turret: 'heavy_turret',
};

const _$ResourceTypeEnumMap = {
  ResourceType.resource1: 'resource1',
  ResourceType.resource2: 'resource2',
  ResourceType.resource3: 'resource3',
};
