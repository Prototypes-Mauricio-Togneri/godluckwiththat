import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/json/json_connections.dart';
import 'package:tensionnode/types/resource_type.dart';

part 'json_woodcutter.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonWoodcutter {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'connections')
  final JsonConnections connections;

  @JsonKey(name: 'resource')
  final ResourceType? resource;

  const JsonWoodcutter({
    required this.location,
    required this.connections,
    this.resource,
  });

  factory JsonWoodcutter.fromString(String json) =>
      JsonWoodcutter.fromJson(jsonDecode(json));

  factory JsonWoodcutter.fromJson(Map<String, dynamic> json) =>
      _$JsonWoodcutterFromJson(json);

  Map<String, dynamic> toJson() => _$JsonWoodcutterToJson(this);
}
