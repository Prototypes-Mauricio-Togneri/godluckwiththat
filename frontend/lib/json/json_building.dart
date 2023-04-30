import 'dart:convert';
import 'package:gatewayguardians/types/building_type.dart';
import 'package:gatewayguardians/types/zone_location.dart';
import 'package:json_annotation/json_annotation.dart';

part 'json_building.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonBuilding {
  @JsonKey(name: 'type')
  final BuildingType type;

  @JsonKey(name: 'level')
  final int level;

  @JsonKey(name: 'workers')
  final int workers;

  @JsonKey(name: 'location')
  final ZoneLocation? location;

  const JsonBuilding({
    required this.type,
    required this.level,
    required this.workers,
    required this.location,
  });

  factory JsonBuilding.fromString(String json) =>
      JsonBuilding.fromJson(jsonDecode(json));

  factory JsonBuilding.fromJson(Map<String, dynamic> json) =>
      _$JsonBuildingFromJson(json);

  Map<String, dynamic> toJson() => _$JsonBuildingToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
