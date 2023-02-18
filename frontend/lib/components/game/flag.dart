import 'package:tensionnode/components/base/node.dart';
import 'package:tensionnode/json/json_flag.dart';
import 'package:tensionnode/models/road.dart';
import 'package:tensionnode/types/node_type.dart';
import 'package:tensionnode/types/resource_type.dart';

class Flag extends Node {
  final List<ResourceType> queue;

  Flag({
    required super.location,
    required this.queue,
  }) : super(type: NodeType.flag);

  @override
  void receive(ResourceType resource) {
    queue.add(resource);
  }

  void _sendResource() {
    if (queue.isNotEmpty) {
      final Road? road = availableRoad;

      if (road != null) {
        final ResourceType resource = queue.removeAt(0);
        road.send(resource);
      }
    }
  }

  JsonFlag get json => JsonFlag(
        location: location.json,
        queue: queue,
        connections: roads.json,
      );

  @override
  void update(double dt) {
    super.update(dt);

    _sendResource();
    debugText.text = queue.toString();
  }
}
