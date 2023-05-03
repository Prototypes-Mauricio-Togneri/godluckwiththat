import 'dart:convert';
import 'package:gatewayguardians/json/json_colony.dart';
import 'package:gatewayguardians/json/json_map.dart';
import 'package:gatewayguardians/json/json_zone.dart';
import 'package:json_annotation/json_annotation.dart';

part 'json_match.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMatch {
  @JsonKey(name: 'version')
  final int version;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'totalTimeElapsed')
  final num totalTimeElapsed;

  @JsonKey(name: 'level')
  final int level;

  @JsonKey(name: 'map')
  final JsonMap map;

  @JsonKey(name: 'zones')
  final List<JsonZone> zones;

  @JsonKey(name: 'colonies')
  final List<JsonColony> colonies;

  const JsonMatch({
    required this.version,
    required this.id,
    required this.totalTimeElapsed,
    required this.level,
    required this.map,
    required this.zones,
    required this.colonies,
  });

  factory JsonMatch.fromString(String json) =>
      JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) =>
      _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
