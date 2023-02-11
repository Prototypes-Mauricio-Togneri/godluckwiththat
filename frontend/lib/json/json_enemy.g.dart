// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_enemy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonEnemy _$JsonEnemyFromJson(Map<String, dynamic> json) => JsonEnemy(
      type: $enumDecode(_$NodeTypeEnumMap, json['type']),
      position:
          (json['position'] as List<dynamic>).map((e) => e as num).toList(),
      shield: json['shield'] as num,
    );

Map<String, dynamic> _$JsonEnemyToJson(JsonEnemy instance) => <String, dynamic>{
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
  NodeType.turret_heavy: 'turret_heavy',
  NodeType.turret_machine_gun: 'turret_machine_gun',
  NodeType.enemy1: 'enemy1',
  NodeType.enemy2: 'enemy2',
};
