import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionplanet/json/json_zone.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/types/resource_type.dart';

part 'json_colony.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonColony {
  @JsonKey(name: 'inventory')
  final JsonInventory inventory;

  @JsonKey(name: 'freeVillagers')
  final int freeVillagers;

  @JsonKey(name: 'zones')
  final List<JsonZone> zones;

  const JsonColony({
    required this.inventory,
    required this.freeVillagers,
    required this.zones,
  });

  factory JsonColony.fromString(String json) =>
      JsonColony.fromJson(jsonDecode(json));

  factory JsonColony.fromJson(Map<String, dynamic> json) =>
      _$JsonColonyFromJson(json);

  Map<String, dynamic> toJson() => _$JsonColonyToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
