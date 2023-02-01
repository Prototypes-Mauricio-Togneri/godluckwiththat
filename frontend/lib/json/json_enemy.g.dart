// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_enemy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonEnemy _$JsonEnemyFromJson(Map<String, dynamic> json) => JsonEnemy(
      type: $enumDecode(_$NodeTypeEnumMap, json['type']),
      position:
          (json['position'] as List<dynamic>).map((e) => e as int).toList(),
      shield: (json['shield'] as num).toDouble(),
      direction: $enumDecode(_$DirectionEnumMap, json['direction']),
    );

Map<String, dynamic> _$JsonEnemyToJson(JsonEnemy instance) => <String, dynamic>{
      'type': _$NodeTypeEnumMap[instance.type]!,
      'position': instance.position,
      'shield': instance.shield,
      'direction': _$DirectionEnumMap[instance.direction]!,
    };

const _$NodeTypeEnumMap = {
  NodeType.kernel: 'kernel',
  NodeType.mine_red: 'mine_red',
  NodeType.mine_green: 'mine_green',
  NodeType.mine_blue: 'mine_blue',
  NodeType.turret_light: 'turret_light',
  NodeType.enemy: 'enemy',
};

const _$DirectionEnumMap = {
  Direction.up: 'up',
  Direction.down: 'down',
  Direction.left: 'left',
  Direction.right: 'right',
};
