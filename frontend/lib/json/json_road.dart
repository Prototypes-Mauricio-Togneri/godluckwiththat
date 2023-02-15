import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';

part 'json_road.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonRoad {
  @JsonKey(name: 'locationA')
  final JsonLocation locationA;

  @JsonKey(name: 'locationB')
  final JsonLocation locationB;

  const JsonRoad({
    required this.locationA,
    required this.locationB,
  });

  factory JsonRoad.fromString(String json) =>
      JsonRoad.fromJson(jsonDecode(json));

  factory JsonRoad.fromJson(Map<String, dynamic> json) =>
      _$JsonRoadFromJson(json);

  Map<String, dynamic> toJson() => _$JsonRoadToJson(this);
}
