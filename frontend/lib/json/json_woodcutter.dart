import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/models/location.dart';
import 'package:tensionnode/types/resource_type.dart';

part 'json_woodcutter.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonWoodcutter {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'resource')
  final ResourceType? resource;

  @JsonKey(name: 'roadNorth')
  final JsonLocation? roadNorth;

  @JsonKey(name: 'roadEast')
  final JsonLocation? roadEast;

  @JsonKey(name: 'roadSouth')
  final JsonLocation? roadSouth;

  @JsonKey(name: 'roadWest')
  final JsonLocation? roadWest;

  const JsonWoodcutter({
    required this.location,
    this.resource,
    this.roadNorth,
    this.roadEast,
    this.roadSouth,
    this.roadWest,
  });

  Map<String, Location> get locations {
    final Map<String, Location> result = {};

    if (roadNorth != null) {
      result['north'] = roadNorth!.location;
    }

    if (roadEast != null) {
      result['east'] = roadEast!.location;
    }

    if (roadSouth != null) {
      result['south'] = roadSouth!.location;
    }

    if (roadWest != null) {
      result['west'] = roadWest!.location;
    }

    return result;
  }

  factory JsonWoodcutter.fromString(String json) =>
      JsonWoodcutter.fromJson(jsonDecode(json));

  factory JsonWoodcutter.fromJson(Map<String, dynamic> json) =>
      _$JsonWoodcutterFromJson(json);

  Map<String, dynamic> toJson() => _$JsonWoodcutterToJson(this);
}
