import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/types/node_type.dart';

part 'json_turret.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonTurret {
  @JsonKey(name: 'type')
  final NodeType type;

  @JsonKey(name: 'position')
  final JsonPosition position;

  @JsonKey(name: 'shield')
  final num shield;

  @JsonKey(name: 'shotsFired')
  final int shotsFired;

  @JsonKey(name: 'kills')
  final int kills;

  const JsonTurret({
    required this.type,
    required this.position,
    required this.shield,
    required this.shotsFired,
    required this.kills,
  });

  factory JsonTurret.fromString(String json) =>
      JsonTurret.fromJson(jsonDecode(json));

  factory JsonTurret.fromJson(Map<String, dynamic> json) =>
      _$JsonTurretFromJson(json);

  Map<String, dynamic> toJson() => _$JsonTurretToJson(this);
}
