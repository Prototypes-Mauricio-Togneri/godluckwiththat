import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/json/json_connections.dart';
import 'package:tensionnode/json/json_inventory.dart';

part 'json_headquarters.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonHeadquarters {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'inventory')
  final JsonInventory inventory;

  @JsonKey(name: 'connections')
  final JsonConnections connections;

  const JsonHeadquarters({
    required this.location,
    required this.inventory,
    required this.connections,
  });

  factory JsonHeadquarters.fromString(String json) =>
      JsonHeadquarters.fromJson(jsonDecode(json));

  factory JsonHeadquarters.fromJson(Map<String, dynamic> json) =>
      _$JsonHeadquartersFromJson(json);

  Map<String, dynamic> toJson() => _$JsonHeadquartersToJson(this);
}
