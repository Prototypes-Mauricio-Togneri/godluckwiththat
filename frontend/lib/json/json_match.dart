import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionplanet/json/json_building.dart';
import 'package:tensionplanet/json/json_headquarters.dart';
import 'package:tensionplanet/json/json_map.dart';
import 'package:tensionplanet/json/json_patches.dart';
import 'package:tensionplanet/types/node_type.dart';

part 'json_match.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMatch {
  @JsonKey(name: 'version')
  final int version;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'totalTimeElapsed')
  final num totalTimeElapsed;

  @JsonKey(name: 'map')
  final JsonMap map;

  @JsonKey(name: 'patches')
  final JsonPatches patches;

  @JsonKey(name: 'headquarters')
  final JsonHeadquarters headquarters;

  @JsonKey(name: 'buildings')
  final Map<NodeType, List<JsonBuilding>> buildings;

  const JsonMatch({
    required this.version,
    required this.id,
    required this.totalTimeElapsed,
    required this.map,
    required this.patches,
    required this.headquarters,
    required this.buildings,
  });

  List<JsonBuilding> getBuildings(NodeType type) => buildings[type] ?? [];

  factory JsonMatch.fromString(String json) =>
      JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) =>
      _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
