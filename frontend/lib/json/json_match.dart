import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/json/json_flag.dart';
import 'package:tensionnode/json/json_headquarters.dart';
import 'package:tensionnode/json/json_map.dart';
import 'package:tensionnode/json/json_woodcutter.dart';

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

  @JsonKey(name: 'headquarters')
  final JsonHeadquarters headquarters;

  @JsonKey(name: 'woodcutters')
  final List<JsonWoodcutter> woodcutters;

  @JsonKey(name: 'flags')
  final List<JsonFlag> flags;

  const JsonMatch({
    required this.version,
    required this.id,
    required this.totalTimeElapsed,
    required this.map,
    required this.headquarters,
    required this.woodcutters,
    required this.flags,
  });

  factory JsonMatch.fromString(String json) =>
      JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) =>
      _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
