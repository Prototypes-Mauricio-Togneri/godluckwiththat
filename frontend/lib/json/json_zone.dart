import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionplanet/json/json_building.dart';
import 'package:tensionplanet/json/json_patch.dart';

part 'json_zone.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonZone {
  @JsonKey(name: 'maxBuildings')
  final int maxBuildings;

  @JsonKey(name: 'patches')
  final List<JsonPatch> patches;

  @JsonKey(name: 'buildings')
  final List<JsonBuilding> buildings;

  const JsonZone({
    required this.maxBuildings,
    required this.patches,
    required this.buildings,
  });

  factory JsonZone.fromString(String json) =>
      JsonZone.fromJson(jsonDecode(json));

  factory JsonZone.fromJson(Map<String, dynamic> json) =>
      _$JsonZoneFromJson(json);

  Map<String, dynamic> toJson() => _$JsonZoneToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
