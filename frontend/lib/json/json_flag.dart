import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/json/json_inventory.dart';
import 'package:tensionnode/models/location.dart';

part 'json_flag.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonFlag {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'inventory')
  final JsonInventory inventory;

  @JsonKey(name: 'roadNorth')
  final JsonLocation? roadNorth;

  @JsonKey(name: 'roadEast')
  final JsonLocation? roadEast;

  @JsonKey(name: 'roadSouth')
  final JsonLocation? roadSouth;

  @JsonKey(name: 'roadWest')
  final JsonLocation? roadWest;

  const JsonFlag({
    required this.location,
    required this.inventory,
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

  factory JsonFlag.fromString(String json) =>
      JsonFlag.fromJson(jsonDecode(json));

  factory JsonFlag.fromJson(Map<String, dynamic> json) =>
      _$JsonFlagFromJson(json);

  Map<String, dynamic> toJson() => _$JsonFlagToJson(this);
}
