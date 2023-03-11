import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionplanet/extensions/json_location_extension.dart';
import 'package:tensionplanet/models/inventory.dart';
import 'package:tensionplanet/types/resource_type.dart';

part 'json_building.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonBuilding {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'inventory')
  final JsonInventory inventory;

  const JsonBuilding({
    required this.location,
    required this.inventory,
  });

  factory JsonBuilding.fromString(String json) =>
      JsonBuilding.fromJson(jsonDecode(json));

  factory JsonBuilding.fromJson(Map<String, dynamic> json) =>
      _$JsonBuildingFromJson(json);

  Map<String, dynamic> toJson() => _$JsonBuildingToJson(this);
}
