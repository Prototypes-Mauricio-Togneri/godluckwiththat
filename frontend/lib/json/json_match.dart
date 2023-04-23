import 'dart:convert';
import 'package:gatewayguardians/json/json_colony.dart';
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

  @JsonKey(name: 'colony')
  final JsonColony colony;

  const JsonMatch({
    required this.version,
    required this.id,
    required this.totalTimeElapsed,
    required this.level,
    required this.colony,
  });

  factory JsonMatch.fromString(String json) =>
      JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) =>
      _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
