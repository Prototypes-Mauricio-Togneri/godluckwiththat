// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonNode _$JsonNodeFromJson(Map<String, dynamic> json) => JsonNode(
      type: $enumDecode(_$NodeTypeEnumMap, json['type']),
      position:
          (json['position'] as List<dynamic>).map((e) => e as int).toList(),
      shield: (json['shield'] as num).toDouble(),
    );

Map<String, dynamic> _$JsonNodeToJson(JsonNode instance) => <String, dynamic>{
      'type': _$NodeTypeEnumMap[instance.type]!,
      'position': instance.position,
      'shield': instance.shield,
    };

const _$NodeTypeEnumMap = {
  NodeType.kernel: 'kernel',
  NodeType.mine_red: 'mine_red',
  NodeType.mine_green: 'mine_green',
  NodeType.mine_blue: 'mine_blue',
  NodeType.turret_light: 'turret_light',
  NodeType.enemy: 'enemy',
};
