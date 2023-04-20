import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionplanet/json/json_building.dart';
import 'package:tensionplanet/json/json_patch.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/types/resource_type.dart';

part 'json_village.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonVillage {
  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'inventory')
  final JsonInventory inventory;

  @JsonKey(name: 'freeVillagers')
  final int freeVillagers;

  @JsonKey(name: 'patches')
  final List<JsonPatch> patches;

  @JsonKey(name: 'buildings')
  final List<JsonBuilding> buildings;

  const JsonVillage({
    required this.name,
    required this.inventory,
    required this.freeVillagers,
    required this.patches,
    required this.buildings,
  });

  factory JsonVillage.fromString(String json) =>
      JsonVillage.fromJson(jsonDecode(json));

  factory JsonVillage.fromJson(Map<String, dynamic> json) =>
      _$JsonVillageFromJson(json);

  Map<String, dynamic> toJson() => _$JsonVillageToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
