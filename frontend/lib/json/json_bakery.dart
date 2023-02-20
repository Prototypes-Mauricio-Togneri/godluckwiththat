import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/json/json_connections.dart';

part 'json_bakery.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonBakery {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'connections')
  final JsonConnections connections;

  const JsonBakery({
    required this.location,
    required this.connections,
  });

  factory JsonBakery.fromString(String json) =>
      JsonBakery.fromJson(jsonDecode(json));

  factory JsonBakery.fromJson(Map<String, dynamic> json) =>
      _$JsonBakeryFromJson(json);

  Map<String, dynamic> toJson() => _$JsonBakeryToJson(this);
}
