import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/types/node_type.dart';

part 'json_enemy.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonEnemy {
  @JsonKey(name: 'type')
  final NodeType type;

  @JsonKey(name: 'position')
  final JsonPosition position;

  @JsonKey(name: 'health')
  final num health;

  const JsonEnemy({
    required this.type,
    required this.position,
    required this.health,
  });

  factory JsonEnemy.fromString(String json) =>
      JsonEnemy.fromJson(jsonDecode(json));

  factory JsonEnemy.fromJson(Map<String, dynamic> json) =>
      _$JsonEnemyFromJson(json);

  Map<String, dynamic> toJson() => _$JsonEnemyToJson(this);
}
