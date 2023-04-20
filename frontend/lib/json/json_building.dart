import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionplanet/types/building_type.dart';
import 'package:tensionplanet/types/patch_location.dart';

part 'json_building.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonBuilding {
  @JsonKey(name: 'type')
  final BuildingType type;

  @JsonKey(name: 'level')
  final int level;

  @JsonKey(name: 'location')
  final PatchLocation? location;

  const JsonBuilding({
    required this.type,
    required this.level,
    required this.location,
  });

  factory JsonBuilding.fromString(String json) =>
      JsonBuilding.fromJson(jsonDecode(json));

  factory JsonBuilding.fromJson(Map<String, dynamic> json) =>
      _$JsonBuildingFromJson(json);

  Map<String, dynamic> toJson() => _$JsonBuildingToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
