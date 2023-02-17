import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/models/connections.dart';

part 'json_connections.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonConnections {
  @JsonKey(name: 'north')
  final JsonLocation? north;

  @JsonKey(name: 'east')
  final JsonLocation? east;

  @JsonKey(name: 'south')
  final JsonLocation? south;

  @JsonKey(name: 'west')
  final JsonLocation? west;

  const JsonConnections({
    this.north,
    this.east,
    this.south,
    this.west,
  });

  Connections get connections {
    final Connections result = Connections();

    if (north != null) {
      result.north = north!.location;
    }

    if (east != null) {
      result.east = east!.location;
    }

    if (south != null) {
      result.south = south!.location;
    }

    if (west != null) {
      result.west = west!.location;
    }

    return result;
  }

  factory JsonConnections.fromString(String json) =>
      JsonConnections.fromJson(jsonDecode(json));

  factory JsonConnections.fromJson(Map<String, dynamic> json) =>
      _$JsonConnectionsFromJson(json);

  Map<String, dynamic> toJson() => _$JsonConnectionsToJson(this);
}
