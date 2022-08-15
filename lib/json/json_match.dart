import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/json/json_map.dart';
import 'package:tensionnode/model/game_map.dart';

part 'json_match.g.dart';

@JsonSerializable()
class JsonMatch {
  @JsonKey(name: 'version')
  final int version;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'map')
  final JsonMap map;

  const JsonMatch({
    required this.version,
    required this.id,
    required this.map,
  });

  GameMap get gameMap => GameMap(
        numberOfBlocksHorizontal: map.numberOfBlocksHorizontal,
        numberOfBlocksVertical: map.numberOfBlocksVertical,
        blockSize: map.blockSize,
      );

  factory JsonMatch.fromString(String json) =>
      JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) =>
      _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);
}
