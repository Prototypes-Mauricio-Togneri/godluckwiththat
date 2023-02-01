import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tension_node_tools/json/json_node.dart';
import 'package:tension_node_tools/json/json_patch.dart';
import 'package:tension_node_tools/json/json_resources.dart';

part 'json_match.g.dart';

@JsonSerializable(includeIfNull: false)
class JsonMatch {
  @JsonKey(name: 'version')
  final num version;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'resources')
  final JsonResources resources;

  @JsonKey(name: 'patches')
  final List<JsonPatch> patches;

  @JsonKey(name: 'nodes')
  final List<JsonNode> nodes;

  const JsonMatch({
    required this.version,
    required this.id,
    required this.resources,
    required this.patches,
    required this.nodes,
  });

  factory JsonMatch.fromString(String json) => JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) => _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);

  String toJsonString() => jsonEncode(toJson());
}
