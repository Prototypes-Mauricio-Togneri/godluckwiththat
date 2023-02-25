import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/json/json_producer.dart';
import 'package:tensionnode/json/json_transformer.dart';

part 'json_buildings.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonBuildings {
  @JsonKey(name: 'coal_mines')
  final List<JsonProducer> coalMines;

  @JsonKey(name: 'cooper_mines')
  final List<JsonProducer> cooperMines;

  @JsonKey(name: 'cooper_furnaces')
  final List<JsonTransformer> cooperFurnaces;

  const JsonBuildings({
    required this.coalMines,
    required this.cooperMines,
    required this.cooperFurnaces,
  });

  factory JsonBuildings.fromString(String json) =>
      JsonBuildings.fromJson(jsonDecode(json));

  factory JsonBuildings.fromJson(Map<String, dynamic> json) =>
      _$JsonBuildingsFromJson(json);

  Map<String, dynamic> toJson() => _$JsonBuildingsToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
