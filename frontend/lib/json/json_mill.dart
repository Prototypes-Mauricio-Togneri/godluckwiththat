import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/json/json_connections.dart';

part 'json_mill.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMill {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'connections')
  final JsonConnections connections;

  const JsonMill({
    required this.location,
    required this.connections,
  });

  factory JsonMill.fromString(String json) =>
      JsonMill.fromJson(jsonDecode(json));

  factory JsonMill.fromJson(Map<String, dynamic> json) =>
      _$JsonMillFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMillToJson(this);
}
