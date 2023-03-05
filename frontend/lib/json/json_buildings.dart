import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/json/json_building.dart';

part 'json_buildings.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonBuildings {
  @JsonKey(name: 'solar_panels')
  final List<JsonBuilding> solarPanels;

  @JsonKey(name: 'iron_mines')
  final List<JsonBuilding> ironMines;

  @JsonKey(name: 'copper_mines')
  final List<JsonBuilding> copperMines;

  @JsonKey(name: 'coal_mines')
  final List<JsonBuilding> coalMines;

  @JsonKey(name: 'stone_mines')
  final List<JsonBuilding> stoneMines;

  @JsonKey(name: 'iron_smelters')
  final List<JsonBuilding> ironSmelters;

  @JsonKey(name: 'copper_smelters')
  final List<JsonBuilding> copperSmelters;

  @JsonKey(name: 'factories_basic')
  final List<JsonBuilding> factoriesBasic;

  const JsonBuildings({
    required this.solarPanels,
    required this.ironMines,
    required this.copperMines,
    required this.coalMines,
    required this.stoneMines,
    required this.ironSmelters,
    required this.copperSmelters,
    required this.factoriesBasic,
  });

  factory JsonBuildings.fromString(String json) =>
      JsonBuildings.fromJson(jsonDecode(json));

  factory JsonBuildings.fromJson(Map<String, dynamic> json) =>
      _$JsonBuildingsFromJson(json);

  Map<String, dynamic> toJson() => _$JsonBuildingsToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
