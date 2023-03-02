import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';

part 'json_building.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonBuilding {
  @JsonKey(name: 'location')
  final JsonLocation location;

  const JsonBuilding({
    required this.location,
  });

  factory JsonBuilding.fromString(String json) =>
      JsonBuilding.fromJson(jsonDecode(json));

  factory JsonBuilding.fromJson(Map<String, dynamic> json) =>
      _$JsonBuildingFromJson(json);

  Map<String, dynamic> toJson() => _$JsonBuildingToJson(this);
}
