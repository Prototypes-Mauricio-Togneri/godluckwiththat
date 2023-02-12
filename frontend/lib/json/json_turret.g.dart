// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_turret.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonTurret _$JsonTurretFromJson(Map<String, dynamic> json) => JsonTurret(
      type: $enumDecode(_$NodeTypeEnumMap, json['type']),
      position:
          (json['position'] as List<dynamic>).map((e) => e as num).toList(),
      health: json['health'] as num,
      shotsFired: json['shotsFired'] as int,
      kills: json['kills'] as int,
    );

Map<String, dynamic> _$JsonTurretToJson(JsonTurret instance) =>
    <String, dynamic>{
      'type': _$NodeTypeEnumMap[instance.type]!,
      'position': instance.position,
      'health': instance.health,
      'shotsFired': instance.shotsFired,
      'kills': instance.kills,
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
