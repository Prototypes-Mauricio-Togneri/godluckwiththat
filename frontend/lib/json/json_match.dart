import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/engine/nodes.dart';
import 'package:tensionnode/engine/patches.dart';
import 'package:tensionnode/json/json_map.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/json/json_patch.dart';
import 'package:tensionnode/json/json_resources.dart';
import 'package:tensionnode/model/game_map.dart';
import 'package:tensionnode/model/nodes/headquarters.dart';

part 'json_match.g.dart';

@JsonSerializable()
class JsonMatch {
  @JsonKey(name: 'version')
  final int version;

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'map')
  final JsonMap map;

  @JsonKey(name: 'resources')
  final JsonResources resources;

  @JsonKey(name: 'patches')
  final List<JsonPatch> patches;

  @JsonKey(name: 'nodes')
  final List<JsonNode> nodes;

  const JsonMatch({
    required this.version,
    required this.id,
    required this.map,
    required this.resources,
    required this.patches,
    required this.nodes,
  });

  GameMap getMap() => GameMap(
        numberOfBlocksHorizontal: map.numberOfBlocksHorizontal,
        numberOfBlocksVertical: map.numberOfBlocksVertical,
        blockSize: map.blockSize,
      );

  Patches getPatches() {
    final Patches result = Patches();

    for (final JsonPatch patch in patches) {
      result.add(patch.getPatch());
    }

    return result;
  }

  Headquarters headquarters() {
    final JsonNode? node = getNode(Offset.zero);

    return node!.getNode(null) as Headquarters;
  }

  Nodes getNodes(Headquarters headquarters) {
    final Nodes result = Nodes();

    for (final JsonNode node in nodes) {
      result.add(node.getNode(headquarters));
    }

    return result;
  }

  JsonNode? getNode(Offset position) {
    for (final JsonNode node in nodes) {
      if ((node.position[0] == position.dx) && (node.position[1] == position.dy)) {
        return node;
      }
    }

    return null;
  }

  factory JsonMatch.fromString(String json) => JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) => _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);
}
