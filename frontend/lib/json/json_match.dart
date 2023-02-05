import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/json/json_enemy.dart';
import 'package:tensionnode/json/json_map.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/json/json_resources.dart';

part 'json_match.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMatch {
  @JsonKey(name: 'version')
  final num version;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'map')
  final JsonMap map;

  @JsonKey(name: 'resources')
  final JsonResources resources;

  @JsonKey(name: 'kernel')
  final JsonNode kernel;

  @JsonKey(name: 'mines')
  final List<JsonNode> mines;

  @JsonKey(name: 'turrets')
  final List<JsonNode> turrets;

  @JsonKey(name: 'enemies')
  final List<JsonEnemy> enemies;

  const JsonMatch({
    required this.version,
    required this.id,
    required this.map,
    required this.resources,
    required this.kernel,
    required this.mines,
    required this.turrets,
    required this.enemies,
  });

  factory JsonMatch.fromString(String json) =>
      JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) =>
      _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
