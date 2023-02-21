import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/json/json_connections.dart';

part 'json_transformer.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonTransformer {
  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'connections')
  final JsonConnections connections;

  const JsonTransformer({
    required this.location,
    required this.connections,
  });

  factory JsonTransformer.fromString(String json) =>
      JsonTransformer.fromJson(jsonDecode(json));

  factory JsonTransformer.fromJson(Map<String, dynamic> json) =>
      _$JsonTransformerFromJson(json);

  Map<String, dynamic> toJson() => _$JsonTransformerToJson(this);
}
