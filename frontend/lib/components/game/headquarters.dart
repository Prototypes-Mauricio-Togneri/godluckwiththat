import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_node.dart';
import 'package:tensionnode/types/node_type.dart';

class Headquarters extends Node {
  Headquarters({
    required super.location,
    required super.resources,
  }) : super(type: NodeType.headquarters);

  JsonNode get json => JsonNode(
        type: type,
        location: location.json,
        resources: resources.json,
      );
}
