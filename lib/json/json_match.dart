import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/engine/lanes.dart';
import 'package:tensionnode/engine/nodes.dart';
import 'package:tensionnode/json/json_lane.dart';
import 'package:tensionnode/json/json_map.dart';
import 'package:tensionnode/json/json_node.dart';
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

  @JsonKey(name: 'nodes')
  final List<JsonNode> nodes;

  @JsonKey(name: 'lanes')
  final List<JsonLane> lanes;

  const JsonMatch({
    required this.version,
    required this.id,
    required this.map,
    required this.nodes,
    required this.lanes,
  });

  GameMap getMap() => GameMap(
        numberOfBlocksHorizontal: map.numberOfBlocksHorizontal,
        numberOfBlocksVertical: map.numberOfBlocksVertical,
        blockSize: map.blockSize,
      );

  Nodes getNodes() {
    final Nodes result = Nodes();

    for (final JsonNode node in nodes) {
      result.add(node.getNode());
    }

    return result;
  }

  Lanes getLanes(Nodes nodes) {
    final Lanes result = Lanes();

    for (final JsonLane lane in lanes) {
      result.add(
        nodes.at(lane.from.x, lane.from.y),
        nodes.at(lane.to.x, lane.to.y),
      );
    }

    return result;
  }

  factory JsonMatch.fromString(String json) => JsonMatch.fromJson(jsonDecode(json));

  factory JsonMatch.fromJson(Map<String, dynamic> json) => _$JsonMatchFromJson(json);

  Map<String, dynamic> toJson() => _$JsonMatchToJson(this);
}
