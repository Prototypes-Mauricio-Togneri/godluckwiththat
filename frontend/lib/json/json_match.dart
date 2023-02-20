import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/json/json_flag.dart';
import 'package:tensionnode/json/json_headquarters.dart';
import 'package:tensionnode/json/json_map.dart';
import 'package:tensionnode/json/json_mill.dart';
import 'package:tensionnode/json/json_producer.dart';
import 'package:tensionnode/json/json_sawmill.dart';

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
  final List<JsonProducer> woodcutters;

  @JsonKey(name: 'quarries')
  final List<JsonProducer> quarries;

  @JsonKey(name: 'wells')
  final List<JsonProducer> wells;

  @JsonKey(name: 'fishers')
  final List<JsonProducer> fishers;

  @JsonKey(name: 'hunters')
  final List<JsonProducer> hunters;

  @JsonKey(name: 'cropFarms')
  final List<JsonProducer> cropFarms;

  @JsonKey(name: 'sawmills')
  final List<JsonSawmill> sawmills;

  @JsonKey(name: 'mills')
  final List<JsonMill> mills;

  @JsonKey(name: 'flags')
  final List<JsonFlag> flags;

  const JsonMatch({
    required this.version,
    required this.id,
    required this.totalTimeElapsed,
    required this.map,
    required this.headquarters,
    required this.woodcutters,
    required this.quarries,
    required this.wells,
    required this.fishers,
    required this.hunters,
    required this.cropFarms,
    required this.sawmills,
    required this.mills,
    required this.flags,
  });

  factory JsonMatch.fromString(String json) =>
      JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) =>
      _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
