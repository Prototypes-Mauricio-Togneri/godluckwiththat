import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tension_node_tools/extensions/json_position_extension.dart';
import 'package:tension_node_tools/types/behavior_type.dart';

part 'json_node.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonNode {
  @JsonKey(name: 'type')
  final NodeType type;

  @JsonKey(name: 'position')
  final JsonPosition position;

  @JsonKey(name: 'shield')
  final double shield;

  const JsonNode({
    required this.type,
    required this.position,
    required this.shield,
  });

  factory JsonNode.fromString(String json) => JsonNode.fromJson(jsonDecode(json));

  factory JsonNode.fromJson(Map<String, dynamic> json) => _$JsonNodeFromJson(json);

  Map<String, dynamic> toJson() => _$JsonNodeToJson(this);
}
