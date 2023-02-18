import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/json/json_connections.dart';

part 'json_sawmill.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonSawmill {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'connections')
  final JsonConnections connections;

  const JsonSawmill({
    required this.location,
    required this.connections,
  });

  factory JsonSawmill.fromString(String json) =>
      JsonSawmill.fromJson(jsonDecode(json));

  factory JsonSawmill.fromJson(Map<String, dynamic> json) =>
      _$JsonSawmillFromJson(json);

  Map<String, dynamic> toJson() => _$JsonSawmillToJson(this);
}
