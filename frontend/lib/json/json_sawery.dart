import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/json/json_connections.dart';

part 'json_sawery.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonSawery {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'connections')
  final JsonConnections connections;

  const JsonSawery({
    required this.location,
    required this.connections,
  });

  factory JsonSawery.fromString(String json) =>
      JsonSawery.fromJson(jsonDecode(json));

  factory JsonSawery.fromJson(Map<String, dynamic> json) =>
      _$JsonSaweryFromJson(json);

  Map<String, dynamic> toJson() => _$JsonSaweryToJson(this);
}
