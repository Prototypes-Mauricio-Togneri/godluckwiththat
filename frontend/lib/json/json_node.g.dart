// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonNode _$JsonNodeFromJson(Map<String, dynamic> json) => JsonNode(
      type: $enumDecode(_$NodeTypeEnumMap, json['type']),
      position:
          (json['position'] as List<dynamic>).map((e) => e as num).toList(),
      health: json['health'] as num,
    );

Map<String, dynamic> _$JsonNodeToJson(JsonNode instance) => <String, dynamic>{
      'type': _$NodeTypeEnumMap[instance.type]!,
      'position': instance.position,
      'health': instance.health,
    };

const _$NodeTypeEnumMap = {
  NodeType.kernel: 'kernel',
  NodeType.mine_red: 'mine_red',
  NodeType.mine_green: 'mine_green',
  NodeType.mine_blue: 'mine_blue',
  NodeType.turret_light: 'turret_light',
  NodeType.turret_heavy: 'turret_heavy',
  NodeType.turret_machine_gun: 'turret_machine_gun',
  NodeType.enemy1: 'enemy1',
  NodeType.enemy2: 'enemy2',
  NodeType.enemy3: 'enemy3',
};
