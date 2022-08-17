import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tensionnode/extensions/json_position_extension.dart';
import 'package:tensionnode/model/nodes/defense.dart';
import 'package:tensionnode/model/nodes/headquarters.dart';
import 'package:tensionnode/model/nodes/intersection.dart';
import 'package:tensionnode/model/nodes/mine.dart';
import 'package:tensionnode/model/nodes/node.dart';
import 'package:tensionnode/model/nodes/power_plant.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

part 'json_node.g.dart';

@JsonSerializable()
class JsonNode {
  @JsonKey(name: 'type')
  final NodeType type;

  @JsonKey(name: 'hp')
  final num hp;

  @JsonKey(name: 'resource')
  final ResourceType? resource;

  @JsonKey(name: 'position')
  final JsonPosition position;

  const JsonNode({
    required this.type,
    required this.hp,
    required this.resource,
    required this.position,
  });

  Node getNode() {
    switch (type) {
      case NodeType.headquarters:
        return Headquarters(
          position: position.position,
          hp: hp,
        );
      case NodeType.mine:
        return Mine(
          position: position.position,
          hp: hp,
          resourceType: resource!,
        );
      case NodeType.power_plant:
        return PowerPlant(
          position: position.position,
          hp: hp,
        );
      case NodeType.defense:
        return Defense(
          position: position.position,
          hp: hp,
        );
      case NodeType.intersection:
        return Intersection(
          position: position.position,
          hp: hp,
        );
    }
  }

  factory JsonNode.fromString(String json) => JsonNode.fromJson(jsonDecode(json));

  factory JsonNode.fromJson(Map<String, dynamic> json) => _$JsonNodeFromJson(json);

  Map<String, dynamic> toJson() => _$JsonNodeToJson(this);
}
