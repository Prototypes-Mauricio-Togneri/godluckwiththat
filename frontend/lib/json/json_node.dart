import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_location_extension.dart';
import 'package:tensionnode/json/json_resources.dart';
import 'package:tensionnode/types/node_type.dart';

part 'json_node.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonNode {
  @JsonKey(name: 'type')
  final NodeType type;

  @JsonKey(name: 'location')
  final JsonLocation location;

  @JsonKey(name: 'resources')
  final JsonResources resources;

  const JsonNode({
    required this.type,
    required this.location,
    required this.resources,
  });

  factory JsonNode.fromString(String json) =>
      JsonNode.fromJson(jsonDecode(json));

  factory JsonNode.fromJson(Map<String, dynamic> json) =>
      _$JsonNodeFromJson(json);

  Map<String, dynamic> toJson() => _$JsonNodeToJson(this);
}
