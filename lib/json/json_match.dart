import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/engine/connections.dart';
import 'package:tensionnode/engine/nodes.dart';
import 'package:tensionnode/engine/patches.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/json/json_connection.dart';
import 'package:tensionnode/json/json_map.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/json/json_patch.dart';
import 'package:tensionnode/json/json_resources.dart';
import 'package:tensionnode/model/game_map.dart';

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

  @JsonKey(name: 'connections')
  final List<JsonConnection> connections;

  const JsonMatch({
    required this.version,
    required this.id,
    required this.map,
    required this.resources,
    required this.patches,
    required this.nodes,
    required this.connections,
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

  Nodes getNodes() {
    final Nodes result = Nodes();

    for (final JsonNode node in nodes) {
      result.add(node.getNode());
    }

    return result;
  }

  Connections getConnections(Nodes nodes) {
    final Connections result = Connections();

    for (final JsonConnection connections in connections) {
      result.add(
        nodes.at(connections.from.position),
        nodes.at(connections.to.position),
      );
    }

    return result;
  }

  factory JsonMatch.fromString(String json) => JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) => _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);
}
