import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

part 'json_node.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonNode {
  @JsonKey(name: 'type')
  final NodeType type;

  @JsonKey(name: 'resource')
  final ResourceType? resource;

  @JsonKey(name: 'position')
  final JsonPosition position;

  const JsonNode({
    required this.type,
    required this.resource,
    required this.position,
  });

  factory JsonNode.fromString(String json) => JsonNode.fromJson(jsonDecode(json));

  factory JsonNode.fromJson(Map<String, dynamic> json) => _$JsonNodeFromJson(json);

  Map<String, dynamic> toJson() => _$JsonNodeToJson(this);
}
