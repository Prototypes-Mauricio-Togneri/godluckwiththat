import 'dart:convert';
import 'package:gatewayguardians/json/json_patch.dart';
import 'package:gatewayguardians/types/zone_status.dart';
import 'package:json_annotation/json_annotation.dart';

part 'json_zone.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonZone {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'x')
  final double x;

  @JsonKey(name: 'y')
  final double y;

  @JsonKey(name: 'owner')
  final String owner;

  @JsonKey(name: 'maxBuildings')
  final int maxBuildings;

  @JsonKey(name: 'status')
  final ZoneStatus status;

  @JsonKey(name: 'patches')
  final List<JsonPatch> patches;

  static const double CENTER_X = 184.5;
  static const double CENTER_Y = 160.5;
  static const double RADIUS = 157;

  const JsonZone({
    required this.id,
    required this.x,
    required this.y,
    required this.owner,
    required this.maxBuildings,
    required this.status,
    required this.patches,
  });

  factory JsonZone.fromString(String json) =>
      JsonZone.fromJson(jsonDecode(json));

  factory JsonZone.fromJson(Map<String, dynamic> json) =>
      _$JsonZoneFromJson(json);

  Map<String, dynamic> toJson() => _$JsonZoneToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
